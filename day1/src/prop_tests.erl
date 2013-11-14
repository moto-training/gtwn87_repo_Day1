-module(prop_tests).
-include_lib("proper/include/proper.hrl"). 
-include_lib("eunit/include/eunit.hrl").

%prop_delete() ->
%    ?FORALL({X,L}, {integer(),list(integer())},
%            not lists:member(X, lists:delete(X, L))).

prop_func01_test() ->
	?FORALL({X,L}, {pos_integer(),list(pos_integer())},
            lists:member(start_app:func01(L,X), L)).
 
proper_test() ->
  ?assertEqual(
    [],
    proper:module(?MODULE, [{to_file, user},
                            {numtests, 1000}])
    ).
