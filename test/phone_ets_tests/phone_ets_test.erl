%%%-------------------------------------------------------------------
%%% @author erlang
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. Feb 2020 11:40
%%%-------------------------------------------------------------------
-module(phone_ets_test).
-author("erlang").

-include_lib("eunit/include/eunit.hrl").

reading_data_test() ->
  ?assertEqual(20, length(phone_ets:read_file()))
.
