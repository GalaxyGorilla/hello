% Copyright 2010-2015, Travelping GmbH <info@travelping.com>

% Permission is hereby granted, free of charge, to any person obtaining a
% copy of this software and associated documentation files (the "Software"),
% to deal in the Software without restriction, including without limitation
% the rights to use, copy, modify, merge, publish, distribute, sublicense,
% and/or sell copies of the Software, and to permit persons to whom the
% Software is furnished to do so, subject to the following conditions:

% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.

% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
% FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
% DEALINGS IN THE SOFTWARE.

% @doc This module provide helpers for metrics

-module (hello_metrics).

-include("metrics.hrl").
-include_lib("ex_uri/include/ex_uri.hrl").

-export([create_server/1,
         create_client/1,
         delete_server/1,
         delete_client/1]).
-export([update_server_request/3, update_server_time/2, update_server_packet/3,
         update_client_request/3, update_client_time/2]).
-export([to_atom/1, atomize_ex_uri/1, timestamp/1, update_uptime/1]).

-type server_name() :: atom().
-type client_name() :: atom().
-type atom_ip() :: atom().
-type atom_port() :: atom().
-type client_metrics_info() :: {client_name(), server_name(), atom_ip(), atom_port()}.
-type server_metrics_info() :: {server_name(), atom_ip(), atom_port()}.
-type request_type() :: atom().
-type packet_size() :: integer().

%% -------------------------------------------------------
%% API for metric creation
%% -------------------------------------------------------
-spec create_server(server_metrics_info()) -> ok.
create_server(MetricsInfo) ->
    create(server, MetricsInfo).

-spec delete_server(server_metrics_info()) -> ok.
delete_server(MetricsInfo) ->
    delete(server, MetricsInfo).

-spec create_client(client_metrics_info()) -> ok.
create_client(MetricsInfo) ->
    create(client, MetricsInfo).

-spec delete_client(client_metrics_info()) -> ok.
delete_client(MetricsInfo) ->
    delete(client, MetricsInfo).

%% -------------------------------------------------------
%% API for metric updates.
%% -------------------------------------------------------
-spec update_server_request(request_type(), server_metrics_info(), integer()) -> any().
update_server_request(pending, Address, Pending) ->
    update_request(server, pending, Address, Pending);
update_server_request(Type, Address, Ms) ->
    [update_request(server, ReqType, Address, Ms) || ReqType <- [Type, total]],
    update_server_time(last_request, Address).

-spec update_server_time(last_reset | last_request, server_metrics_info()) -> any().
update_server_time(Type, Address) ->
    update_time(server, Type, Address).

-spec update_server_packet(in | out, server_metrics_info(), packet_size()) -> any().
update_server_packet(Type, Address, Size) ->
    update_packet(server, Type, Address, Size).

-spec update_client_request(request_type(), client_metrics_info(), integer()) -> any().
update_client_request(pending, MetricsInfo, Pending) ->
    update_request(client, pending, MetricsInfo, Pending);
update_client_request(Type, MetricsInfo, Ms) ->
    [update_request(client, ReqType, MetricsInfo, Ms) || ReqType <- [Type, total]],
    update_client_time(last_request, MetricsInfo).

-spec update_client_time(last_request, client_metrics_info()) -> any().
update_client_time(last_request, MetricsInfo) ->
    update_time(client, last_request, MetricsInfo).

-spec timestamp(erlang:time_unit()) -> integer().
timestamp(Unit) ->
    try
        erlang:system_time(Unit)
    catch %% fallback for erlang 17 and older
        error:undef ->
            {MegaSecs, Secs, MicroSecs} = os:timestamp(),
                case Unit of
                    seconds         ->         Secs + (MegaSecs * 1000000) + (MicroSecs / 10000000);
                    milli_seconds   -> 1000 * (Secs + (MegaSecs * 1000000) + (MicroSecs / 10000000))
                end
    end.

%% -----------------------------------------------------------------
%% Internal
%% -----------------------------------------------------------------
create(Service, Args) ->
    metrics_action(create, Service, Args).

delete(Service, Args) ->
    metrics_action(delete, Service, Args).

metrics_action(Action, Service, Args) ->
    Metrics = proplists:get_value(Service, ?METRICS, undefined),
    {ok, MetricsOpts} = application:get_env(hello, metrics),
    EnabledServices = proplists:get_value(enabled, MetricsOpts, []),
    case lists:member(Service, EnabledServices) of
        true ->
            proceed_metrics_action(Action, Service, Args, Metrics);
        false ->
            ok
    end.

%% this function traverses the datastructures in metrics.hrl
proceed_metrics_action(Action, Service, Args, Metrics) ->
    lists:foreach(
        fun({MetricName, MetricType, Units}) ->
            lists:foreach(
                fun({UnitType, {ExoType, ExoTypeOpts}}) ->
                    PartId = case Service of
                                      server    -> server_layout(Args);
                                      client    -> client_layout(Args)
                                  end,
                    %% this is the final exometer id:
                    FinalId = lists:append([?DEFAULT_ENTRIES, [MetricName, MetricType],
                                            PartId, [UnitType]]),
                    case Action of
                        create ->
                            case ExoType of
                                {function,_,_,_,_,_} ->
                                    % functions are tricky, they need further arguments and
                                    % will not be initialized at start
                                    exometer:new(FinalId, setelement(4, ExoType, [Args]), ExoTypeOpts);
                                _ ->
                                    exometer:update_or_create(FinalId, 0, ExoType, ExoTypeOpts)
                            end;
                        delete ->
                            exometer:delete(FinalId)
                    end
                end, Units)
        end, Metrics).

update_request(server, Type, Args, Ms) ->
    Args1 = server_layout(Args),
    update_exo_request(Type, Args1, Ms);
update_request(client, Type, Args, Ms) ->
    Args1 = client_layout(Args),
    update_exo_request(Type, Args1, Ms).

update_time(server, Type, Args) ->
    Sec = timestamp(milli_seconds),
    Args1 = server_layout(Args),
    update_exo_time(Type, Args1, Sec);
update_time(client, Type, Args) ->
    Sec = timestamp(milli_seconds),
    Args1 = client_layout(Args),
    update_exo_time(Type, Args1, Sec).

update_packet(server, Type, Args, Size) ->
    Args1 = server_layout(Args),
    update_exo_packet(Type, Args1, Size).

update_exo_request(pending, Args, Value) ->
    PartId = lists:append([?DEFAULT_ENTRIES, [request, pending], Args]),
    exometer:update(PartId ++ [gauge], Value);
update_exo_request(Type, Args, Ms) ->
    PartId = lists:append([?DEFAULT_ENTRIES, [request, Type], Args]),
    exometer:update(PartId ++ [counter], 1),
    exometer:update(PartId ++ [ticks], Ms).

update_exo_time(Type, Args, Sec) ->
    PartId = lists:append([?DEFAULT_ENTRIES, [time, Type], Args]),
    exometer:update(PartId ++ [gauge], Sec).

update_exo_packet(Type, Args, Size) ->
    PartId = lists:append([?DEFAULT_ENTRIES, [packet, Type], Args]),
    exometer:update(PartId ++ [counter], 1),
    exometer:update(PartId ++ [size], Size).

server_layout({ServerName, ServerIP, ServerPort}) ->
    [server, ServerName, ServerIP, ServerPort, total, undefined, undefined].
client_layout({ClientName, ClientIP, ServerName, ServerIP, ServerPort}) ->
    [client, ClientName, ClientIP, undefined, ServerName, ServerIP, ServerPort].

to_atom(Value) when is_atom(Value) -> Value;
to_atom(Value) when is_binary(Value) -> binary_to_atom(Value, latin1);
to_atom(Value) when is_list(Value) -> list_to_atom(Value).

protocol("zmq-tcp6") -> inet6;
protocol(_) -> inet.

parse_ex_uri_ip(inet, "*") -> {ok, {0,0,0,0}};
parse_ex_uri_ip(inet, Host) -> inet:parse_ipv4_address(Host);

parse_ex_uri_ip(inet6, "*") -> {ok, {0,0,0,0,0,0,0,0}};
parse_ex_uri_ip(inet6, Host) ->
    case re:run(Host, "^\\[(.*)\\]$", [{capture, all, list}]) of
        {match, ["[::1]", IP]} ->
            inet:parse_ipv6_address(IP);
        _ ->
            inet:parse_ipv6_address(Host)
    end.

atomize_ex_uri(#ex_uri{scheme = Scheme, authority = #ex_uri_authority{host = Host, port = Port}}) ->
    {ok, IP} = parse_ex_uri_ip(protocol(Scheme), Host),
    {ip_to_atom(IP), port_to_atom(Port)}.

ip_to_atom(IP) when is_atom(IP) -> IP;
ip_to_atom(IP) -> list_to_atom(inet:ntoa(IP)).

port_to_atom(undefined) -> undefined;
port_to_atom(Port) when is_atom(Port) -> Port;
port_to_atom(Port) -> list_to_atom(integer_to_list(Port)).

update_uptime(ServerAddress) ->
    Args = server_layout(ServerAddress),
    LastResetId = lists:append([?DEFAULT_ENTRIES, [time, last_reset], Args, [gauge]]),
    {ok, [{value, ServerStartTime}, _]} = exometer:get_value(LastResetId),
    CurrentTime = timestamp(milli_seconds),
    [{value, round(CurrentTime - ServerStartTime)}].
