-module(csv_parser).
-compile(export_all).

%---------------------------
% main function
%---------------------------
p(File) ->
	% open file
	% read_file(Filename) -> {ok, Binary} | {error, Reason}
	{ok, Binary} = file:read_file(File),

    % parse file into lines
    % split(Subject, Pattern, Options) -> Parts
    % options = [global]
	Lines = binary:split(Binary, <<"\n">>, [global]),
	
	% parse lines into lists
	PLines = [ parse(Line, out, <<>>, []) || Line <- Lines ],
	
	% parse elements
	Result = [ [ convert(Elem) || Elem <- PLine, Elem =/= <<>> ] || PLine <- PLines ],
	
	% create list of tuples
	[ list_to_tuple(L) || L <- Result ].
	
%-------------------------------
% parses line into list of terms
%-------------------------------

parse(<<>>, _, AccTerm, AccList) -> lists:reverse([AccTerm | AccList]);	

parse(<<"\"", Rest/binary>>, out, AccTerm, AccList) -> 
	parse(<<Rest/binary>>, in_quotes, <<AccTerm/binary, "\"">>, AccList);
	
parse(<<"\"", Rest/binary>>, in_quotes, AccTerm, AccList) -> 
	parse(<<Rest/binary>>, out, <<AccTerm/binary, "\"">>, AccList);

parse(<<",", Rest/binary>>, out, AccTerm, AccList) -> 
	parse(<<Rest/binary>>, out, <<>>, [AccTerm | AccList]);
	
parse(<<" ", Rest/binary>>, out, AccTerm, AccList) -> 
	parse(<<Rest/binary>>, out, AccTerm, AccList);

parse(<<"\r", Rest/binary>>, out, AccTerm, AccList) -> 
	parse(<<Rest/binary>>, out, AccTerm, AccList);

parse(<<B:1/binary, Rest/binary>>, _State, AccTerm, AccList) -> 
	parse(Rest, _State, <<AccTerm/binary, B:1/binary>>, AccList).
	
	
%-----------------------------------------------
% converts binary elements into int/float/string	
% and removes <<>>, " ", \r
%-----------------------------------------------
convert(Elem) -> 
		try 
			binary_to_integer(Elem) of
				Int -> Int
		catch
			_Class:_Error ->
				try
					binary_to_float(Elem) of
						Float -> Float
				catch 
					_Class:_Error ->
						Elem
				end
		end.
	
%---------------------------
	
test() ->
		p("or.csv").
	