-module(server).
-author("acteek").

%% API
-export([]).
-compile(export_all).


-record(state,{events,clients}).

-record(event,{name = "",
  description = "",
  pid,
  timeout = {{1970,1,1},{0,0,0}}
}).


init() ->
  loop(#state{events = orddict:new(),
    clients = orddict:new()
    }).




loop(S = #state{} )  ->
  receive
    {Pid, MsgRef, {subscribe, Client}} ->
      Ref = erlang:monitor(process, Client),
      NewClient = orddict:store(Ref, Client, S#state.clients),
      Pid ! {MsgRef, ok},
      loop(S#state{clients = NewClient});

    {Pid, MsgRef, {add, Name, Desctiption, TimeOut}} ->
      ok;
    {Pid, MsgRef, {cancel, Name}} ->
      ok;
    {done, Name} ->
      ok;
    shutdown ->
      ok;
    { 'DOWN' , Ref , process , _Pid , _Reason} ->
      ok;
    code_change ->
      ok;
    Unknown ->
      io:format("Unknown message:~p~n",[Unknown]),
      loop(S)
  end.
