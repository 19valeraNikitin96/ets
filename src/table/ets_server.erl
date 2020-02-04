%%%-------------------------------------------------------------------
%%% @author erlang
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. Feb 2020 14:51
%%%-------------------------------------------------------------------
-module(ets_server).
-author("erlang").

%% API
-export([setup/1]).
-export([server/0]).

setup(Abonents)->
  Server_PID = spawn(ets_server, server, []),
  Server_PID ! {setup, Abonents},
  Server_PID
  .
%%PID = ets_server:setup(phone_ets:read_file()).
server()->
  receive
    {setup,Abonents} ->
      TableID = ets:new(abonents, [duplicate_bag]),
      put(abonents, TableID),
      insertAll(Abonents, TableID),
      server();
    {get,_From,Key} ->
      io:format("~w~n", [ets:lookup(get(abonents), Key)]),
      server();
    {all} ->
      io:format("~w~n", [ets:tab2list(get(abonents))]),
      server();
    {summary} ->
      io:format("~w~n", [summary()]),
      server()
  end
.

summary() ->
    Abonents = ets:tab2list(get(abonents)),
    summary(Abonents, #{})
  .

summary([], Map) ->Map;
summary([H|T], Map) ->
  {abonent, Phone, StartDate, StartTime, EndDate, EndTime } = H,
  [SYear, SMonth, SDay] = string:split(StartDate, "-", all),
  [EYear, EMonth, EDay] = (string:split(EndDate, "-", all)),
  [SHours, SMinutes, SSeconds] = (string:split(StartTime, ":", all)),
  [EHours, EMinutes, ESeconds] = (string:split(EndTime, ":", all)),
  Seconds =
%%  TODO optimize converting to integer using function of higher order
    calendar:datetime_to_gregorian_seconds({{list_to_integer(EYear), list_to_integer(EMonth), list_to_integer(EDay)},{list_to_integer(EHours), list_to_integer(EMinutes), list_to_integer(ESeconds)}}) -
    calendar:datetime_to_gregorian_seconds({{list_to_integer(SYear), list_to_integer(SMonth), list_to_integer(SDay)},{list_to_integer(SHours), list_to_integer(SMinutes), list_to_integer(SSeconds)}}),
  case maps:get(Phone, Map, undefined)==undefined of
    true -> summary(T, maps:put(Phone, Seconds, Map));
    false -> summary(T, maps:put(Phone, Seconds+maps:get(Phone, Map), Map))
  end
.

insertAll([], _TableID) -> true;
insertAll([H|T], TableID) ->
  ets:insert(TableID,H), insertAll(T, TableID)
.