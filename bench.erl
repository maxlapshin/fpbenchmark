#!/usr/bin/env escript
%% -smp enable

-mode(compile).
-compile(export_all).

-record(stat, {
  requests = 0,
  errors = 0,
  timeouts = 0,
  bytes = 0,
  ms10 = 0,
  ms50 = 0,
  ms100 = 0,
  ms500 = 0,
  ms1000 = 0,
  ms2000 = 0,
  long = 0
}).

-record(req, {
  url,
  addr,
  port,
  request
}).


main([]) ->
  io:format("~s http://url/ [out.csv]~n", [escript:script_name()]),
  erlang:halt(1);

main([URL|Out]) ->
  catch erlang:system_flag(scheduler_bind_type, spread),
  ets:new(http_stats, [public,named_table]),
  ets:insert(http_stats, #stat{}),
  ets:insert(http_stats, {pool_size, 0}),

  % Resolve our url first
  {ok, {http, _, Host, Port, Path, Query}} = http_uri:parse(URL),
  {ok, Addr} = inet:getaddr(Host, inet),
  Request = iolist_to_binary([<<"GET ">>, Path, Query, <<" HTTP/1.1\r\nHost: ">>, Host, <<"\r\nConnection: keepalive\r\n\r\n">>]),

  io:format("URL: ~s~nHost: ~p, Addr: ~p~nPort: ~p~nRequest: ~p~n~n", [URL, Host, Addr, Port, Request]),

  _Pool = spawn_link(fun() ->
    F = case Out of
      [CSVPath] ->
        {ok, F_} = file:open(CSVPath, [binary,raw,write]),
        file:write(F_, "Request,Kbps,Errors,Timeouts,10ms,50ms,100ms,500ms,1000ms,2000ms,long\n"),
        F_;
      [] ->
        undefined
    end,
    collector(F)
  end),

  Collector = spawn_link(fun() ->
    pool(#req{url = URL, addr = Addr, port = Port, request = Request})
  end),
  register(http_pool, Collector),
  control(),
  ok.

control() ->
  case io:get_line("command> ") of
    "add " ++Count_ when length(Count_) > 1 ->
      Count = list_to_integer(string:strip(Count_,both,$\n)),
      http_pool ! {add, Count},
      control();
    "remove " ++Count_ when length(Count_) > 1 ->
      Count = list_to_integer(string:strip(Count_,both,$\n)),
      http_pool ! {remove, Count},
      control();
    [$q|_] ->
      halt(0);
    _ ->
      io:format("help|add Count|remove Count|quit\n"),
      control()
  end.







collector(F) ->
  timer:sleep(1000),
  [#stat{requests = R, bytes = B, errors = E, timeouts = T,
  ms10 = MS10, ms50 = MS50, ms100 = MS100, ms500 = MS500, ms1000 = MS1000, ms2000 = MS2000, long = L}] = ets:lookup(http_stats, stat),
  ets:insert(http_stats, #stat{}),
  [{pool_size, Count}] = ets:lookup(http_stats, pool_size),
  io:format("Requests: ~6.. B/s, errors: ~6.. B/s, timeouts: ~6.. B/s, workers: ~p~n", [R, E, T, Count]),
  case F of
    undefined -> ok;
    _ ->
      file:write(F, io_lib:format("~B,~B,~B,~B,~B,~B,~B,~B,~B,~B,~B\n", [
        R, B*8 div 1024,E,T, MS10, MS50, MS100, MS500, MS1000, MS2000, L
      ]))
  end,
  collector(F).


pool(Req) ->
  pool(Req, [], 10).


pool(Req, Workers, Count) when length(Workers) < Count ->
  Worker = spawn(fun() ->
    start_worker(Req, length(Workers))
  end),
  erlang:monitor(process, Worker),
  ets:insert(http_stats, {pool_size, length(Workers) + 1}),
  pool(Req, [Worker|Workers], Count);

pool(Req, Workers, Count) when length(Workers) == Count ->
  receive
    {'DOWN', _, process, Worker, _} -> pool(Req, lists:delete(Worker, Workers), Count);
    {add, Number} -> pool(Req, Workers, Count + Number);
    {remove, Number} -> pool(Req, Workers, Count + Number);
    Else -> exit(Else)
  end.




start_worker(#req{url = URL} = Req, N) ->
  put(worker, {N, URL}),
  loop_worker(Req, undefined).


loop_worker(Req, Socket) ->
  T1 = erlang:now(),
  case fetch(Req, Socket) of
    {error, closed} -> 
      ok;
    {error, timeout} ->
      ets:update_counter(http_stats, stat, {#stat.timeouts, 1}),
      ok;
    {error, _Error} ->
      ets:update_counter(http_stats, stat, {#stat.errors, 1}),
      % io:format("error: ~p~n", [_Error]),
      ok;
    {ok, Socket1, Body} ->
      T2 = erlang:now(),
      Time = timer:now_diff(T2,T1) div 1000,
      TimeSlot = if
        Time =< 10 -> #stat.ms10;
        Time =< 50 -> #stat.ms50;
        Time =< 100 -> #stat.ms100;
        Time =< 500 -> #stat.ms500;
        Time =< 1000 -> #stat.ms1000;
        Time =< 2000 -> #stat.ms2000;
        true -> #stat.long
      end,
      ets:update_counter(http_stats, stat, [{#stat.requests, 1},{TimeSlot,1},{#stat.bytes,size(Body)}]),
      loop_worker(Req, Socket1)
  end.








-define(TIMEOUT, 2000).


-spec fetch(Req::#req{}, Socket::port() | undefined) -> {error, Reason::term()} | {ok, Socket::port(), Body::binary()}.
fetch(Req, Socket) ->
  fetch(Req, Socket, 5).

-spec fetch(Req::#req{}, Socket::port() | undefined, RetryCount::non_neg_integer()) -> {error, Reason::term()} | {ok, Socket::port(), Body::binary()}.
fetch(Req, Socket, Count) ->
  try fetch0(Req, Socket, Count)
  catch
    throw:{error, Reason} ->
      {error, Reason};
    throw:{restart, Req, NewCount} ->
      fetch(Req, undefined, NewCount)
  end.

fetch0(#req{addr = Addr, port = Port} = Req, undefined, Count) ->
  {ok, Socket} = case gen_tcp:connect(Addr, Port, [binary, {active,false}, {send_timeout, ?TIMEOUT}]) of
    {ok, S} -> {ok, S};
    {error, _} = Error -> throw(Error)
  end,
  fetch0(Req, Socket, Count);

fetch0(#req{request = Request} = Req, Socket, RetryCount) ->
  inet:setopts(Socket, [{active,false}, {packet, http_bin}]),
  gen_tcp:send(Socket, Request),
  case gen_tcp:recv(Socket, 0, ?TIMEOUT) of
    {ok, {http_response, _HttpVersion, 200, _HttpString}} ->
      ok;
    {ok, {http_response, _HttpVersion, Code, _HttpString}} ->
      gen_tcp:close(Socket),
      throw({error, Code});
    {error, closed} when RetryCount > 1 ->
      gen_tcp:close(Socket),
      throw({restart, Req, RetryCount - 1});
    {error, Error} ->
      gen_tcp:close(Socket),
      throw({error, Error})
  end,

  HeaderRead = fun(F, Sock, BodyLen) ->
    case gen_tcp:recv(Sock, 0, ?TIMEOUT) of
      {ok, http_eoh} -> BodyLen;
      {ok, {http_header, _, 'Content-Length', _, Length}} ->
        F(F, Socket, list_to_integer(binary_to_list(Length)));
      {ok, {http_header, _, _Header, _, _Value}} ->
        F(F, Sock, BodyLen);
      % {error, closed} when RetryCount > 1 ->
      %   gen_tcp:close(Socket),
      %   throw({restart, URL, RetryCount - 1});
      {error, Reason} ->
        gen_tcp:close(Sock),
        throw({error, {header,Reason}})
    end
  end,
  case HeaderRead(HeaderRead, Socket, undefined) of
    undefined ->
      {ok, Socket, undefined};
    ContentLength ->
      inet:setopts(Socket, [{packet,raw}]),
      case gen_tcp:recv(Socket, ContentLength) of
        {ok, Body} ->
          % io:format("Fetched ~s (~B bytes)~n", [URL, size(Body)]),
          {ok, Socket, Body};
        {error, Reason} ->
          gen_tcp:close(Socket),
          throw({error, {body, ContentLength, Reason}})
      end
  end.

