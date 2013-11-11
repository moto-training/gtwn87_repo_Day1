-module(csv_parser).
-compile(export_all).

p(File) ->
	% open file
	% read_file(Filename) -> {ok, Binary} | {error, Reason}
	{ok, Binary} = file:read_file(File),

    % parse into lines
    % split(Subject, Pattern, Options) -> Parts
    % options = [global]
	Lines = binary:split(Binary, <<"\n">>, [global]).

	%[list_to_tuple(binary:bin_to_list(Line)) || Line <- Lines].
	% parse lines into binary
	%PLines = [begin 
	%			Parts = binary:split(Line, <<",">>, [global]),
	%			[ list_to_tuple(Part) || Part <- Parts ]	
	%          end || Line <- Lines].


