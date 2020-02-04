%%%-------------------------------------------------------------------
%%% @author erlang
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. Feb 2020 12:58
%%%-------------------------------------------------------------------
-module(phone_ets).
-author("erlang").
-include("phone_records.hrl").
%% API
-export([read_file/0, read_file/1, read_file/2]).

read_file()->
  read_file(?FILENAME)
.
read_file(Filename)->
  {Status, InputFile} = file:open(Filename, [read]),
  case Status /= ok of
    true -> undefined;
    false -> read_file(InputFile, [])
  end
.
read_file(File, Result)->
  Line = io:get_line(File, ""),
  case Line == eof of
    true -> Result;
    false ->
      [Phone, StartDate, StartTime, EndDate, EndTime] = string:split(string:trim(Line),",",all),
      read_file(File,
        [#abonent{
          phoneNumber = Phone,
          startingDate = StartDate,
          startingTime =  StartTime,
          endDate = EndDate,
          endTime = EndTime} | Result
        ])
  end
.

