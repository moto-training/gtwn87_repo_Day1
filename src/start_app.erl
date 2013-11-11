-module(start_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).
-compile(export_all).
-import(lists).
-import(random).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    start_sup:start_link().

stop(_State) ->
    ok.

%% ===================================================================
%% Tasks 1-6
%% ===================================================================
% 1. find K element
func01([],_) -> empty;
func01([_],K) when K<1 -> invalid_K;
func01([Head|_],1) -> Head;
func01([_|[]],_) -> too_big_K;
func01([_|Tail], K) ->
	K1 = K - 1,
	func01(Tail, K1).

% 2. remove K element
func02([], _) -> empty;
func02([_], K) when K<1 -> invalid_K;
func02(List, K) -> func02(List, K, []).

func02([], _, Sum) -> lists:reverse(Sum);
func02([_|Tail], 1, Sum) -> 
	func02(Tail, 0, Sum);
func02([Head|Tail], K, Sum) ->
	func02(Tail, K - 1, [Head|Sum]).


% 3. split list into 2 parts of K len and the rest
func03([], _) -> empty;
func03(_, K) when K < 1 -> invalid_K;
func03(List, K) ->
	func03(List, K, []).

func03(List1, 0, List2) ->
	{lists:reverse(List2), List1};
func03([Head|Tail], K, List2) ->
	func03(Tail, K - 1, [Head|List2]).


% 4. create random elements' replacement
func04([]) -> [];
func04(List) -> 
	func04(List,[]).

func04([], New) -> New;
func04(List, New) -> 
	K = random:uniform(length(List)),
   func04(func02(List, K), [func01(List, K)|New]).
	

% 5. flattern list
func05([]) -> [];
func05(List) -> lists:reverse(func05(List, [])).

func05([], Flat) -> Flat;
func05([Head|Tail], Flat) when not is_list(Head) ->
	func05(Tail, [Head|Flat]);
func05([Head|Tail], Flat) when is_list(Head) ->
	Inner = func05(Head, []),
	func05(Tail, lists:append(Inner,Flat)).


% 6. RLE encode/decode
% RUN-LENGTH encoding
% [a,b,b,b,c] -> [a,{3,b},c]
