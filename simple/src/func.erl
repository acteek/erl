-module(func).
-author("acteek").


%% API
-export([]).
-compile(export_all).


print_string(String) ->
  io:format("You write string: <<~s>>~n", [String]).

head([H | _]) ->
  H.

second([_, S | _]) ->
  S.

%%Рекурсия
fac(0) -> 1;
fac(N) when N > 0 ->
  N * fac(N - 1).

%%Хвостовая рекурсия
tail_fac(N) -> tail_fac(N, 1).

tail_fac(0, Acc) -> Acc;
tail_fac(N, Acc) when N > 0 ->
  tail_fac(N - 1, N * Acc).

%% Длинна списка
len(List) -> len(List, 0).

len([], Acc) -> Acc;
len([_ | T], Acc) -> len(T, Acc + 1).


duplicate(N, Term) ->
  duplicate(N, Term, []).

duplicate(0, _, Acc) ->
  Acc;
duplicate(N, Term, Acc) ->
  duplicate(N - 1, Term, [Term | Acc]).

add_head(List,El) -> [El|List].