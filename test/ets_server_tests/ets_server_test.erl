%%%-------------------------------------------------------------------
%%% @author erlang
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. Feb 2020 11:42
%%%-------------------------------------------------------------------
-module(ets_server_test).
-author("erlang").

-include_lib("eunit/include/eunit.hrl").

setup_test() ->
  PID = ets_server:setup(phone_ets:read_file()),
  ?assert(is_pid(PID)),
  PID ! {delete}
.