-module(ets_serv).
 
-behaviour(gen_server).

% DB server, day 4
% Creates DB
% Serves read/write request from tcp_serv
% Stores DB every 5 min

%% API
%-export([start_link/0, inc/1]).
-export([start_link/0, read/1, write/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).
 
-define(SERVER, ?MODULE).
-define(File, "UserBD.ets"). % Initial data base storage
-define(Bckp, "BackupDB.ets"). % Backup storage / updated every 5 min
 
%-record(state, {}).
 
%%% API
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%read, write
%inc(Pid) ->
%	gen_server:call(Pid, increment).

read(Data) ->
    gen_server:call(?SERVER, {read, Data}).

write(Data) ->
    gen_server:call(?SERVER, {write, Data}).

%%% gen_server callbacks
init([]) ->
    self() ! init,
    {ok, empty}.

handle_call(_Request, _From, empty) ->
    io:format("Error: data base is empty, got invalid request ~p from ~p~n", [_Request, _From]),
    {noreply, empty};
handle_call({read, UserID}, _From, State) ->
    Reply = db:read(UserID),
    {reply, Reply, State}; 
handle_call({write, Data}, _From, State) ->
    db:write(Data),
    {reply, ok, State};
handle_call(_Request, _From, State) ->
    io:format("Error: invalid request ~p ~p ~p~n", [_Request, _From, State]),
    {noreply, State}.

 
handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(init, empty) ->
    {done, UserDB, _} = db:load(?File), 
    erlang:send_after(300000, self(), flush),
    {noreply, UserDB};
handle_info(flush, State) ->
    db:save(?Bckp), 
    erlang:send_after(300000, self(), flush),
    {noreply, State};
handle_info(_Info, State) ->
    {noreply, State}.
 
terminate(_Reason, _State) ->
    %db:save(?Bckp),
    ok.
 
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
 
%%% Internal functions