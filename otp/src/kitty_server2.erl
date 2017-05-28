-module(kitty_server2).
-author("acteek").

%% API
-export([start_link/0, order_cat/4, close_shop/1, return_cat/2]).
-export([handle_call/3, handle_cast/2, init/0]).
-record(cat, {name, color = green, description}).


%%% Client API

start_link() ->
  my_server:start_link(?MODULE, []).

order_cat(Pid, Name, Color, Description) ->
  my_server:call(Pid, {order, Name, Color, Description}).

return_cat(Pid, Cat = #cat{}) ->
  my_server:cast(Pid, {return, Cat}).

close_shop(Pid) ->
  my_server:call(Pid, terminate).

%% Server functions
init() -> [].

handle_call({order, Name, Color, Description}, From, Cats) ->
  if Cats =:= [] ->
    my_server:reply(From, make_cat(Name, Color, Description)),
    Cats;
    Cats =/= [] ->
      my_server:reply(From, hd(Cats)),
      tl(Cats)
  end;

handle_call(terminate, From, Cats) ->
  my_server:reply(From, ok),
  terminate(Cats).

handle_cast({return, Cat = #cat{}}, Cats) ->
  [Cat | Cats].


%%% Private functions
make_cat(Name, Col, Desc) ->
  #cat{name = Name, color = Col, description = Desc}.

terminate(Cats) ->
  [io:format("~p was set free. ~n", [C#cat.name]) || C <- Cats],
  ok.