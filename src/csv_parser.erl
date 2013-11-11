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

% parse lines into binary



% compose & print tuples

