-module(pong).
-compile(export_all).

start() ->
	Player1 = spawn (fun() -> player() end),
	spawn (fun() -> player({send, Player1, ping}) end).

player() ->
	receive
		{ping, Pid} -> 
			io:format("~p got ping from ~p~n", [self(), Pid]),
			Pid ! {pong, self()};
		{pong, Pid} -> 
			io:format("~p got pong from ~p~n", [self(), Pid]),
			Pid ! {ping, self()}
		after 
			60000 -> {no_one_is_online}
	end,
	timer:sleep(1000 * random:uniform(10)),
	player().
	
player({send, Pid, Text}) ->
	Pid ! {Text, self()},
	timer:sleep(1000 * random:uniform(5)),
	player().