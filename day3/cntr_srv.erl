-module(cntr_srv).
 
-behaviour(gen_server).
 
% example of gen_server usage: increase counter++ by call event, day3

%% API
-export([start_link/0, inc/1]).
 
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).
 
-define(SERVER, ?MODULE).
 
-record(state, {}).
 
%%% API
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

inc(Pid) ->
	gen_server:call(Pid, increment).

%%% gen_server callbacks
init([]) ->
    {ok, 0}.
 
handle_call(increment, _From, State) -> 
	NState = State + 1,
	Reply = ok,
	io:format("~p ~p ~p~n",[increment, _From, NState]),
    {reply, Reply, NState};
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.
 
handle_cast(_Msg, State) ->
    {noreply, State}.
 
handle_info(_Info, State) ->
    {noreply, State}.
 
terminate(_Reason, _State) ->
    ok.
 
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
 
%%% Internal functions