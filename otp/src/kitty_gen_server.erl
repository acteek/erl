-module(kitty_gen_server).

-behavior(gen_server).

-author("acteek").

%% API
-export([start_link/0, order_cat/4, close_shop/1, return_cat/2]).
-export([handle_call/3, handle_cast/2, init/1, handle_info/2, terminate/2, code_change/3]).

-record(cat, {name, color = green, description}).


%%% Client API

start_link() ->
  gen_server:start_link(?MODULE, [], []).

order_cat(Pid, Name, Color, Description) ->
  gen_server:call(Pid, {order, Name, Color, Description}).

return_cat(Pid, Cat = #cat{}) ->
  gen_server:cast(Pid, {return, Cat}).

close_shop(Pid) ->
  gen_server:call(Pid, terminate).

%% Server functions
init([]) -> {ok, []}.

handle_call({order, Name, Color, Description}, _From, Cats) ->
  if Cats =:= [] ->
    {reply, make_cat(Name, Color, Description), Cats};
    Cats =/= [] ->
      {reply, hd(Cats), tl(Cats)}
  end;

handle_call(terminate, _From, Cats) ->
  {stop, normal, ok, Cats}.

handle_cast({return, Cat = #cat{}}, Cats) ->
  [noreply, Cat | Cats].


handle_info(Msg, Cats) ->
  io:format(" Unexpected message : ~p~n", [Msg]),
  {noreply, Cats}.


%%% Private function
make_cat(Name, Col, Desc) ->
  #cat{name = Name, color = Col, description = Desc}.


terminate(normal, Cats) ->
  [io:format("~p was set free. ~n", [C#cat.name]) || C <- Cats],
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.