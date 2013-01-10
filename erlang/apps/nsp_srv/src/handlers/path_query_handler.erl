-module (path_query_handler).
-behaviour (query_handler).
-include_lib ("nitrogen_core/include/wf.hrl").

-export ([
    init/2,
    finish/2,
    get_value/3,
    get_values/3,
    add_path_params/2
]).

init(_Config, _State) ->
    % Get query params and post params
    % from the request bridge...
    RequestBridge = wf_context:request_bridge(),
    QueryParams = RequestBridge:query_params(),
    PostParams = RequestBridge:post_params(),

    % Load into state...
    Params = QueryParams ++ PostParams,

    % Pre-normalize the parameters.
    Params1 = [{normalize_path(Path), Value} || {Path, Value} <- Params, Path /= undefined, Path /= []],
    {ok, Params1}.

finish(_Config, _State) ->
    % Clear out the state.
    {ok, []}.


add_path_params(_Config, State) ->
    BasePath = wf:path_info(),
    Module   = wf:page_module(),
    Routing  = routing(Module),
    PathParams = get_params_from_path(BasePath, Routing),
    Params = [{normalize_path(Path), Value} || {Path, Value} <- PathParams, Path /= undefined, Path /= []],
    {ok, Params ++ State}.

%% split path to pairs of {Key, Value} if applicable
get_params_from_path(Path, Routing) ->
    Splited = string:tokens(Path, "/"),
    case {Routing, length(Splited) rem 2, Splited} of
        {Route, _, Splited} when is_list(Route)->
            Routed = apply_route(Route, Splited),
            path_params(Routed);

        %% first element is submodule. Rest are params.
        %% For this case add aditional param {'__submodule__', Submodule}
        %% /module/somesub/param/value -> [{'__submodule__', "somesub"}, {param, "value"}]
        {_, 1, [Sub | Rest]} ->
            path_params(["__submodule__", Sub | Rest]);

        %% When prams applied directrly to module, just remove module
        %% from path. /module/param/value -> [{param, "value"}]
        {_, 0, Params} ->
            path_params(Params);

        {_, _, []} ->
            []
    end.

%% Given a path, return the value that matches the path.
get_value(Path, Config, State) ->
    case get_values(Path, Config, State) of
        [] -> undefined;
        [One] -> One;
        _Many -> throw({?MODULE, too_many_matches, Path})
    end.

get_values(Path, _Config, State) ->
    Params = State,
    Path1 = normalize_path(Path),
    refine_params(Path1, Params).

%% Next, narrow down the parameters by keeping only the parameters
%% that contain the next element found in path, while shrinking the
%% parameter paths at the same time.
%% For example, if:
%% 	Path   = [a, b, c]
%% 	Params = [{[x, a, y, b, c], _}]
%% Then after the first round of refine_params/2 we would have:
%%   Path   = [b, c]
%%   Params = [y, b, c]
refine_params([], Params) ->
    [V || {_, V} <- Params];
refine_params([H|T], Params) ->
    F = fun({Path, Value}, Acc) ->
        case split_on(H, Path) of
            {ok, RemainingPath} -> [{RemainingPath, Value}|Acc];
            false -> Acc
        end
    end,
    Params1 = lists:foldl(F, [], Params),
    refine_params(T, lists:reverse(Params1)).

split_on(_,  []) -> false;
split_on(El, [El|T]) -> {ok, T};
split_on(El, [_|T]) -> split_on(El, T).

normalize_path(Path) when is_atom(Path) ->
    normalize_path(atom_to_list(Path));

normalize_path(Path) when ?IS_STRING(Path) ->
    Tokens = string:tokens(Path, "."),
    Tokens1 = [strip_wfid(X) || X <- Tokens],
    lists:reverse(Tokens1).

%% Most tokens will start with "wfid_". Strip this out.
strip_wfid(Path) ->
    case Path of
        "wfid_" ++ S -> S;
        S -> S
    end.

routing(Module) ->
    case catch Module:route() of
        {'EXIT', _} ->
            undefined;
        Routes ->
            Routes
    end.

apply_route([R|RT], [P|PT]) -> [R, P|apply_route(RT, PT)];
apply_route([], []) -> [];
apply_route([], P)  -> P;
apply_route(_R, []) -> [].


path_params([]) ->
    [];
path_params([Key]) ->
    [{strip_dash(Key), true}];
path_params([Key, Value | Rest]) ->
    [{strip_dash(Key), Value}|path_params(Rest)].

%% replace "-" with "_"
strip_dash([]) ->
    [];
strip_dash([H|T]) ->
    [case H of
         $- -> $_;
         _  -> H
     end | strip_dash(T)].

