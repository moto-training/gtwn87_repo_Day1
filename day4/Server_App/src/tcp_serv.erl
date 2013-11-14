-module(tcp_serv).
-export([start_server/2,start_link/0]).

%-define(MOD, vocab).
%-define(PORT, 1400).

% telnet service, day4
% creates connections with clients
% currently Mod = vocab, later other modules may be used as translators
% tcp_serv:start_server(1400, vocab).

start_link() ->
    {ok, Port} = application:get_env(srv, port),
    {ok, Mod} = application:get_env(srv, mod),
    Pid = spawn_link(fun() -> start_server(Port, Mod) end),
    {ok, Pid}.

start_server(Port, Mod) ->
    {ok, Listen} = gen_tcp:listen(Port, [binary, {active, false}, {reuseaddr, true}]),
    spawn(fun() -> acceptor(Listen, Mod) end),
    receive
        X ->
            io:format("Info: Got message ~p~n", [X])
    end,
    ok.

acceptor(ListenSocket, Mod) ->
    {ok, Socket} = gen_tcp:accept(ListenSocket),
    spawn(fun() -> acceptor(ListenSocket, Mod) end),
    handle(Socket, Mod).

handle(Socket, Mod) ->
    inet:setopts(Socket, [{active, once}]),
    receive
        {tcp, Socket, Msg} ->
            io:format("Debug: Got message ~p~n", [Msg]),
        	case Mod:handle_msg(Msg) of
                {skip} -> 
                    handle(Socket, Mod);
        		{reply, Answer} ->
            		gen_tcp:send(Socket, Answer),
            		handle(Socket, Mod);
            	{stop, Answer} ->
            		io:format("Info: Closed socket ~p~n", [Socket]),
            		gen_tcp:send(Socket, Answer)
            end;
        X ->
        	io:format("Info: Got message ~p~n", [X])

    after
    	300000 ->
            io:format("Info: Closed socket ~p~n", [Socket]), 
        	Msg = <<"Closing inactive connection after 5 min\n\r">>, 
            gen_tcp:send(Socket, Msg)
    end.

