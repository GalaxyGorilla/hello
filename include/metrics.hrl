%% This file contains the definitions for all metrics used by exometer.
%%
%% First the used entries and probes for exometer will be described and
%% then the actual metrics. These definitions contain the way metrics are
%% exposed, e.g. for requests:
%%
%%   - request handle time (ticks)
%%   - request counter (counter)
%%
%% In a similar way this holds for other metrics.

%% this will be prepended to all eradius metrics
-define(DEFAULT_ENTRIES, [hello, api]).

-define(METRICS, [{server,  ?SERVER_METRICS},
                  {client,  ?CLIENT_METRICS}]).

%% exometer basic configuration used for metrics
-define(COUNTER,        {counter,   %% exometer type
                         []}).      %% type options

-define(GAUGE,          {gauge,
                         []}).

-define(HISTOGRAM_1000, {histogram,
                         [{slot_period, 100},
                          {time_span, 1000}]}).

-define(FUNCTION_UPTIME,{{function,
                          eradius_metrics,
                          update_uptime,
                          undefined,
                          proplist,
                          [value]},
                         []}).

-define(BASIC_REQUEST_METRICS, [
     {request, total, [
       {ticks, ?HISTOGRAM_1000},
       {counter, ?COUNTER}]},
     {request, success, [
       {ticks, ?HISTOGRAM_1000},
       {counter, ?COUNTER}]},
     {request, error, [
       {ticks, ?HISTOGRAM_1000},
       {counter, ?COUNTER}]},
     {request, internal, [
       {ticks, ?HISTOGRAM_1000},
       {counter, ?COUNTER}]},
     {request, ping, [
       {ticks, ?HISTOGRAM_1000},
       {counter, ?COUNTER}]},
     {request, timeout, [
       {ticks, ?HISTOGRAM_1000},
       {counter, ?COUNTER}]},

     {time, last_request, [
       {gauge, ?GAUGE}]},
     {request, pending, [
       {gauge, ?COUNTER}]}
     ]).

-define(SERVER_METRICS, [
     {time, last_reset, [
       {gauge, ?GAUGE}]},
     {time, up, [
       {gauge, ?FUNCTION_UPTIME}]},
     {packet, in, [
       {counter, ?COUNTER},
       {size, ?HISTOGRAM_1000}]},
     {packet, out, [
       {counter, ?COUNTER},
       {size, ?HISTOGRAM_1000}]}
     ] ++ ?BASIC_REQUEST_METRICS).

-define(CLIENT_METRICS, ?BASIC_REQUEST_METRICS).

