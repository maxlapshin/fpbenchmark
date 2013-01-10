-module(i18n_route_handler).
% -extends(dynamic_route_handler).
% Can't be extend module because dynamic_route_handler should exports mroe functions.
-behaviour (route_handler).

-include_lib("nitrogen_core/include/wf.hrl").

-export ([
          init/2,
          finish/2
         ]).

-define(REGEXP_TO_PLATFORM, [
        {"iPod"              , "iPod"},
        {"iPad"              , "iPad"},
        {"iPhone"            , "iPhone"},
        {"Windows"           , "Windows"},
        {"OS X \\d+[._]\\d+" , "OS X"},
        {"Android"           , "Android"},
        {"Linux"             , "Linux"}
    ]).

-define(REGEXP_TO_BROWSER, [
        {"Konqueror" , "Konqueror"},
        {"Chrome"    , "Chrome"},
        {"Googlebot" , "Googlebot"},
        {"Safari"    , "Safari"},
        {"MSIE"      , "IE"},
        {"Opera"     , "Opera"},
        {"Firefox"   , "Firefox"}
    ]).

browser(UA) -> browser(?REGEXP_TO_BROWSER,UA).
browser([],_UA) -> undefined;
browser([{Regexp, Browser}|T],UA) ->
    case re:run(UA, Regexp, [global, caseless]) of
        {match, _A} -> Browser;
        _          -> browser(T,UA)
    end.

platform(UA) -> platform(?REGEXP_TO_PLATFORM,UA).
platform([],_UA) -> undefined;
platform([{Regexp, OS}|T],UA) ->
    case re:run(UA, Regexp, [global, caseless]) of
        {match, _} -> OS;
        _          -> platform(T,UA)
    end.


init(_Config, State) ->
    % Get the path...
    RequestBridge = wf_context:request_bridge(),
    BasePath = RequestBridge:path(),

    Path = BasePath,
%%        try uri_translator:translate(BasePath)
%%        catch
%            _:{unknown_language, _} ->
%                "404"; 
%            _:{unknown_translation, _, _} ->
%                "404"
%        end,

    % Convert the path to a module. If there are no routes defined, then just
    % convert everything without an extension to a module.
    % Otherwise, look through all routes for the first matching route.
%    {Module, PathInfo} = route(ling:replace(Path, "-", "_")),
%    {Module1, PathInfo1} = check_for_404(Module, PathInfo, Path),

    {Module1, PathInfo1} = route(Path),

    wf_context:page_module(Module1),
    wf_context:path_info(PathInfo1),

    %% CAUTION! This will work only with custom handler which implements
    %% aad_path_params/0 function. After this call we will have parameters from
    %% path in list of the regular params
    wf_handler:call(query_handler, add_path_params, []),

    {ok, State}.

finish(_Config, State) ->
    {ok, State}.

route("/") ->
    {index, []};

route(Path) ->
    IsStatic = (filename:extension(Path) /= []),
    RequestBridge = wf_context:request_bridge(),
    case IsStatic of
        true ->
            {static_file, Path};
        false ->
            Path1 = string:strip(Path, both, $/),
            Tokens = string:tokens(Path1, "/"),
            case try_load_module(Tokens) of
                {Module, PathInfo} ->
%                    UA = RequestBridge:header(user_agent),
%                    OS = case platform(UA) of undefined -> ""; X->X end,
%                    HC = case browser(UA) of undefined -> UA; Y->Y end,
%                    IP = inet_parse:ntoa(RequestBridge:peer_ip()),
%                    {Date,Time} = calendar:local_time(),
%                    case Module of
%                         matchmaker -> skip;
%                         dashboard -> skip;
%                         tournament_lobby -> skip;
%                         buy -> skip;
%                         _ -> nsm_mhits:store(Path,IP,Date), ?INFO("URLPATH: ~s:~s:~s:~s",[IP,Path,OS,HC])
%                    end,
                    {Module, PathInfo};
                undefined ->
                    {web_404, Path1}
            end
    end.

try_load_module(Tokens) -> try_load_module(Tokens, []).
try_load_module([], _ExtraTokens) -> undefined;
try_load_module(Tokens, ExtraTokens) ->
    %% Get the module name...
    ModuleName = string:join(Tokens, "_"),
    Module = try
        list_to_existing_atom(ModuleName)
    catch _:_ ->
        case erl_prim_loader:get_file(ModuleName ++ ".beam") of
            {ok, _, _} -> list_to_atom(ModuleName);
            _ -> list_to_atom("$not_found")
        end
    end,

    %% Load the module, check if it exports the right method...
    code:ensure_loaded(Module),
    case erlang:function_exported(Module, main, 0) of
        true ->
            PathInfo = string:join(ExtraTokens, "/"),
            {Module, PathInfo};
        false ->
            next_try_load_module(Tokens, ExtraTokens)
    end.

next_try_load_module(Tokens, ExtraTokens) ->
    Tokens1 = lists:reverse(tl(lists:reverse(Tokens))),
    ExtraTokens1 = [hd(lists:reverse(Tokens))|ExtraTokens],
    try_load_module(Tokens1, ExtraTokens1).

check_for_404(static_file, _PathInfo, Path) ->
    {static_file, Path};

check_for_404(Module, PathInfo, Path) ->
    % Make sure the requested module is loaded. If it
    % is not, then try to load the web_404 page. If that
    % is not available, then default to the 'file_not_found_page' module.
    case code:ensure_loaded(Module) of
        {module, Module} -> {Module, PathInfo};
        _ ->
            case code:ensure_loaded(web_404) of
                {module, web_404} -> {web_404, Path};
                _ -> {file_not_found_page, Path}
            end
    end.
