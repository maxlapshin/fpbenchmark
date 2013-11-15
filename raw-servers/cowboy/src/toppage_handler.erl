%% Feel free to use, reuse and abuse the code in this file.

%% @doc Hello world handler.
-module(toppage_handler).
-behaviour(cowboy_http_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

init(_Transport, Req, []) ->
	{ok, Req, undefined}.

handle(Req, State) ->
	{ok, Req2} = cowboy_req:reply(200, [], <<"Hello world!">>, Req),
%         error_logger:info_msg("ok"),
	{ok, Req2, State}.

terminate(_Req, _State,_) ->
	ok.
