
-module(box).
-author("acteek").

%% API
-export([start/0, store/2, take/2, stop/1, box_spawn/1,status/1]).


%% Старт актора
start() ->
  Pid = spawn(?MODULE, box_spawn, [[]]),
  io:format("started ~n"),
  Pid.

%% Одидание ответа
expectation_response(Pid) ->
  receive
    {Pid, Msg} -> Msg
  after 3000 -> timeout
  end.

%% Посылка сообщений
store(Pid, Item) ->
  Pid ! {self(),{store,Item}},
  expectation_response(Pid).

take(Pid,Item) ->
  Pid ! {self(), {take, Item}},
  expectation_response(Pid).

stop(Pid) ->
  Pid ! {self(), stop},
  expectation_response(Pid).

status(Pid) ->
  Pid ! {self(), status},
  expectation_response(Pid).



%% Простой актор
box_spawn(StateItems)->
  receive
    {From,{store, Item}} ->
      From ! {self(), {item_added, Item}},
      box_spawn([Item|StateItems]);
    {From,{take, Item}} ->
      case lists:member(Item, StateItems) of
        true ->
          From ! {self(), {ok, Item}},
          box_spawn(lists:delete(Item, StateItems));
        false ->
          From ! {self(), not_found},
          box_spawn(StateItems)
      end;
    {From, stop} ->
      From ! {self(), box_stoped};
    {From, status} ->
      From ! {self(), {in_box, StateItems}},
      box_spawn(StateItems);
    Unexpected ->
        io:format("unexpected message ~p~n",[Unexpected])
  end.