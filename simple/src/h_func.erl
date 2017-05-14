-module(h_func).
-author("acteek").

%% API
-export([map/2,filter/2]).


map(_, []) -> [];
map(F, [H | T]) -> [F(H) | map(F, T)].


filter(Pred, L) ->
  lists:reverse(filter(Pred, L, [])).

filter(_, [], Acc) ->
  Acc;
filter(Pred, [H | T], Acc) ->
  case Pred(H) of
    true -> filter(Pred, T, [H | Acc]);
    false -> filter(Pred, T, Acc)
  end.