-module(myapp_test).
-include_lib("eunit/include/eunit.hrl").

func03_test()->
	?assert(true),
	?assertEqual({[1], [2, 3, 4]}, start_app:func03([1, 2, 3, 4], 1)),
	?assertEqual(empty, start_app:func03([], 16#FF)),
	?assertEqual(invalid_K, start_app:func03([1, 2, 3, 4, 5, 6, 7, 8], 0)),
	?assertEqual({[1, 2, 3, 4, 5, 6, 7, 8], []}, start_app:func03([1, 2, 3, 4, 5, 6, 7, 8], 8)),
	?assertEqual({[1, 2], [3]}, start_app:func03([1, 2, 3], 2)).

