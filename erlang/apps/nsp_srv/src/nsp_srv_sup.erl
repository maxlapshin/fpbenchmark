-module(nsp_srv_sup).
-behaviour(supervisor).
-export([start_link/0,init/1]).

-define(CHILD(M, F, A, Type), {M, {M, F, A}, permanent, 5000, Type, [M]}).

start_link() -> supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) -> {ok, { {one_for_one, 5, 10}, []} }.
