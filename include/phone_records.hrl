%%%-------------------------------------------------------------------
%%% @author erlang
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. Feb 2020 12:54
%%%-------------------------------------------------------------------
-author("erlang").

-record(abonent, {phoneNumber, startingDate, startingTime, endDate, endTime}).

-define(FILENAME, "/home/erlang/IdeaProjects/using_ets/resources/call_data.csv").
%%-define(FILENAME, "resources/call_data.csv").

-define(ABONENTS, abonents).
-define(NULL, undefined).
-define(ABONENT, abonent).

-define(DATE_SEPARATOR, "-").
-define(TIME_SEPARATOR, ":").