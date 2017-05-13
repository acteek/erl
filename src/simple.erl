-module(simple).
-author("acteek").

%% API
-export([hello/0, add/2, hello_add_two/1]).

add(A, B) ->
  A + B.

hello() ->
  io:format("Hello~n").

hello_add_two(X) ->
  hello(),
  add(X, 2).




