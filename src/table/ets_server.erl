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
-include("phone_records.hrl").
%% API
-export([setup/1]).
-export([server/0, summary/1]).

setup(Abonents)->
  Server_PID = spawn(ets_server, server, []),
  Server_PID ! {setup, Abonents},
  Server_PID
  .
%%PID = ets_server:setup(phone_ets:read_file()).
server()->
  receive
    {setup,Abonents} ->
      TableID = ets:new(?ABONENTS, [duplicate_bag]),
      put(?ABONENTS, TableID),
      insertAll(Abonents, TableID),
      server();
    {get,_From,Key} ->
      io:format("~w~n", [ets:lookup(get(?ABONENTS), Key)]),
      server();
    {all} ->
      io:format("~w~n", [ets:tab2list(get(?ABONENTS))]),
      server();
    {summary} ->
      io:format("~w~n", [summary()]),
      server();
    {summary, Phone} ->
      io:format("~w~n", [summary(Phone)]),
      server()
  end
.

summary() ->
    Abonents = ets:tab2list(get(?ABONENTS)),
    summary(Abonents, #{})
.
summary(PhoneNumber)->
  summary(
    lists:filter(
      fun(X)->{_,Phone,_,_,_,_} = X, Phone =:= PhoneNumber end,
      ets:tab2list(get(?ABONENTS))
    ),
    #{}
  )
.
summary([], Map) -> maps:to_list(Map);
summary([H|T], Map) ->
  {?ABONENT, Phone, StartDate, StartTime, EndDate, EndTime } = H,
  [SYear, SMonth, SDay, EYear, EMonth, EDay,SHours, SMinutes, SSeconds,EHours, EMinutes, ESeconds] =
    lists:flatmap(
        fun(X) -> [list_to_integer(X)] end,
        lists:flatmap(fun(X) -> string:split(X, ?DATE_SEPARATOR, all) end, [StartDate, EndDate])
          ++
        lists:flatmap(fun(X) -> string:split(X, ?TIME_SEPARATOR, all) end, [StartTime, EndTime])
    ),
  Seconds =
    calendar:datetime_to_gregorian_seconds({{EYear, (EMonth), (EDay)},{(EHours), (EMinutes), (ESeconds)}}) -
    calendar:datetime_to_gregorian_seconds({{(SYear), (SMonth), (SDay)},{(SHours), (SMinutes), (SSeconds)}}),
  case maps:get(Phone, Map, ?NULL)==?NULL of
    true -> summary(T, maps:put(Phone, Seconds, Map));
    false -> summary(T, maps:put(Phone, Seconds+maps:get(Phone, Map), Map))
  end
.

insertAll([], _TableID) -> true;
insertAll([H|T], TableID) ->
  ets:insert(TableID,H), insertAll(T, TableID)
.