%%%-------------------------------------------------------------------
%%% @author acteek
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. Май 2017 1:52
%%%-------------------------------------------------------------------
-author("acteek").



%% this is a .hrl (header) file.
-record(included, {some_field,
  some_default = "yeah!",
  unimaginative_name}).