-module(somebd).
-compile(export_all).

% create and fulfil the user_table
load(File) ->
	% open BD file
	{ok, Data} = file:consult(File),
	
	% check if UserIDs are unique
	PLines = [ X || {X, _} <- Data ],	
	case sets:size(sets:from_list(PLines)) == length(PLines) of
		false -> io:format("Warning: there are duplicated records in the DB~n");
		true  -> io:format("Info: all records in the DB are unique~n")
	end,
	
	% create table
	UserDB = ets:new(user_table, [named_table]),
	
	% put data in the table 
	ets:insert(user_table, Data),
	{done, UserDB, Data}.
	


% read from user_table by UserID
read(UserID) ->
	ets:lookup(user_table,UserID).
	
% write to user_table
write({UserID, Amount}) ->
	ets:insert(user_table, {UserID, Amount}),
	{done, read(UserID)}.
	
% ets:tab2list
save(File) ->
	Lines = ets:tab2list(user_table),
	[ file:write_file(File, io_lib:fwrite("~p.\n", [Line]), [append]) || Line <- Lines ].

test() ->
	load("UserBD.ets"),
	%save("Saved.ets").
	read(playerQ).    
	%write({playerQ,1}).

