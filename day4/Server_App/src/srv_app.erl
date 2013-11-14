-module(srv_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

-export([start/0]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    srv_sup:start_link().

stop(_State) ->
    ok.


%% tratata

start() ->
	application:start(srv).