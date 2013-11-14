-module(vocab).
-export[handle_msg/1].

% client - server translator
% passes read/write requests to ets_serv

%% API

handle_msg(<<"\r\n">>) -> {skip};
handle_msg(<<"help", _/binary>>) ->
	Msg = <<"Menu: \nread <ID> - read data for specified user \nwrite <ID> <sum> - update/create user record \nquit - to exit \n">>,
	{reply, Msg};
handle_msg(<<"read", Rest/binary>>) ->
	[UserID | _ ] = parse(<<Rest/binary>>),
	[{UserID, Sum}] = ets_serv:read(UserID), % [{playerQ,1166}]
	io:format("Info: Read data for user ~p~n", [UserID]),
	BUser=atom_to_binary(UserID),
	BSum=integer_to_binary(Sum),
	{reply, <<BUser/binary," ", BSum/binary,"\n\r">>}; 
	%{reply, <<"ok\n\r">>};
handle_msg(<<"write", Rest/binary>>) ->
	% error there ->
	[UserID, Sum] = parse(<<Rest/binary>>),
	ets_serv:write({UserID, Sum}), %({UserID, Amount})
	io:format("Info: Wrote data for user ~p sum ~p ~n", [UserID, Sum]),
	{reply, <<"ok\n\r">>};
handle_msg(<<"quit", _/binary>>) ->
	Msg = <<"Bye-bye!\r\n">>,
	{stop, Msg};
handle_msg(Msg) -> {reply, Msg}.

%%% Internal functions

parse(Request) -> 
 [ parse_piece(X) || X <- binary:split(Request, [<<" ">>, <<"\n">>, <<"\r">>], [global, trim] ), X =/= <<>>].


parse_piece(<<A, _/binary>> = Piece) when A >= $a andalso A =< $z ->
    binary_to_existing_atom(Piece, utf8);    
parse_piece(A) -> 
	try binary_to_integer(A)
    catch error:badarg -> 
    	try binary_to_float(A)
		catch error:badarg -> binary_to_list(A)
		end
	end.


binary_to_integer(X) ->
	list_to_integer(binary_to_list(X)).


integer_to_binary(X) ->
	list_to_binary(integer_to_list(X)).


binary_to_float(X) ->
	list_to_float(binary_to_list(X)).


%float_to_binary(X) ->
%	list_to_binary(float_to_list(X)).


atom_to_binary(X) ->
	list_to_binary(atom_to_list(X)).





