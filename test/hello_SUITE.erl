-module(hello_SUITE).
-compile(export_all).

-include_lib("common_test/include/ct.hrl").
-include("hello_test.hrl").
-include("../include/jsonrpc_internal.hrl").

% ---------------------------------------------------------------------
% -- test cases
bind_http(_Config) ->
    [bind_url(?HTTP, Protocol) || Protocol <- ?PROTOCOLS].

bind_zmq_tcp(_Config) ->
    [bind_url(?ZMQ_TCP, Protocol) || Protocol <- ?PROTOCOLS].

unbind_all(_Config) ->
    timer:sleep(300), %% needed for metrics
    Bindings = hello_binding:all(),
    true = (2 * length(?PROTOCOLS) * length(?CALLBACK_MODS)) == length(Bindings),
    [ begin 
          hello:unbind(Url, CallbackMod),
          hello:stop_listener(Url)
      end || {Url, _} <- ?TRANSPORTS, CallbackMod <- ?CALLBACK_MODS ],
    [] = hello_binding:all().

start_supervised(_Config) ->
    [ start_client(Transport) || Transport <- ?TRANSPORTS ],
    [ hello_client_sup:stop_client(Url ++ "/test") || {Url, _} <- ?TRANSPORTS ],
    [] = hello_client_sup:clients(),
    ok.

start_named_supervised(_Config) ->
    [ start_named_client(Transport) || Transport <- ?TRANSPORTS ],
    [ hello_client_sup:stop_client(Url ++ "/test") || {Url, _} <- ?TRANSPORTS ],
    [] = hello_client_sup:clients(),
    ok.

keep_alive(_Config) ->
    [bind_url(?HTTP, Protocol) || Protocol <- ?PROTOCOLS],
    [bind_url(?ZMQ_TCP, Protocol) || Protocol <- ?PROTOCOLS],
    meck:new(hello_client, [passthrough]),
    true = meck:validate(hello_client),
    ok = meck:expect(hello_client, handle_internal, fun(Message, State) -> ct:log("got pong"), meck:passthrough([Message, State]) end),
    {ZMQUrl, ZMQTransportOpts} = ?ZMQ_TCP,
    {ok, ZMQClient} = hello_client:start_supervised(ZMQUrl ++ "/test", ZMQTransportOpts, 
                                                    [{protocol, hello_proto_jsonrpc}], [{keep_alive_interval, 200}] ),
    {HTTPUrl, HTTPTransportOpts} = ?HTTP,
    {ok, HTTPClient} = hello_client:start_supervised(HTTPUrl ++ "/test", HTTPTransportOpts, 
                                                     [{protocol, hello_proto_jsonrpc}], [{keep_alive_interval, 200}] ),
    timer:sleep(500), %% lets wait for some pongs, should be around 3-4; look them up in the ct log
    ct:pal("~p", [exometer:get_values([hello, api, request, total, listener])]),
    {_, [Arg], _} = ?REQ11,
    {ok, Arg} = hello_client:call(ZMQClient, ?REQ11),
    {ok, Arg} = hello_client:call(HTTPClient, ?REQ11),

    % server send no pong
    meck:new(hello_proto, [passthrough]),
    ok = meck:expect(hello_proto, handle_internal, fun(_, _) -> ct:log("no pong"), {ok, <<"NO_PONG">>} end),
    timer:sleep(500), 
    {ok, Arg} = hello_client:call(ZMQClient, ?REQ11),
    {ok, Arg} = hello_client:call(HTTPClient, ?REQ11),
    meck:unload(hello_proto),
    meck:unload(hello_client),
    ok.

% ---------------------------------------------------------------------
% -- common_test callbacks
all() ->
    [bind_http,
     bind_zmq_tcp,
     unbind_all,
     start_supervised,
     start_named_supervised,
     keep_alive
     ].

init_per_suite(Config) ->
    hello:start(),
    [ code:ensure_loaded(Callback) || Callback <- ?CALLBACK_MODS ],
    Config.

end_per_suite(_Config) ->
    application:stop(hello).

% ---------------------------------------------------------------------
% -- helpers
bind_url({Url, _TransportOpts}, Protocol) ->
    spawn(fun() ->
        hello:start_listener(Url, Url, [], Protocol, [], hello_router),
        [ok = hello:bind(Url, Handler, proplists:get_value(Handler, ?HANDLER_ARGS)) || Handler <- ?CALLBACK_MODS],
        receive ok -> ok end
    end).

start_client(Transport) ->
    {Url, TransportOpts} = Transport,
    ProtocolOpts = [{protocol, hello_proto_jsonrpc}],
    {ok, Pid} = hello_client:start_supervised(Url ++ "/test", TransportOpts, ProtocolOpts, []),
    Pid.

start_named_client(Transport) ->
    Name = proplists:get_value(Transport, ?CLIENT_NAMES),
    {Url, TransportOpts} = Transport,
    ProtocolOpts = [{protocol, hello_proto_jsonrpc}],
    {ok, _Pid} = hello_client:start_supervised(Name, Url ++ "/test", TransportOpts, ProtocolOpts, []),
    Name.
