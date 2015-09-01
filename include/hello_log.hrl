-ifndef(HELLO_LOG).
-define(HELLO_LOG, 1).

-include("hello.hrl").
-include("hello_log_ids.hrl").

-define(DEFAULT_TRACES, [{class, hello}]).
-define(DEFAULT_META(Meta, LogId), 
        lists:append([[{status_code, element(1, LogId)}, {message_id, element(2, LogId)}], Meta, ?DEFAULT_TRACES])).

%% hello_handler specific log macros
-define(REQ_TRACES(Mod, HandlerId, Request, Response), 
        lists:append([?REQ_TRACES(Mod, HandlerId, Request), 
                        [{hello_response, hello_log:fmt_response(Response)}] 
                     ])).

-define(REQ_TRACES(Mod, HandlerId, Request), 
        lists:append([?DEFAULT_TRACES, 
                      [ {hello_request, hello_log:fmt_request(Request)}, 
                        {hello_service_id, HandlerId},
                        {hello_handler_callback, Mod}
                      ]
                     ])).

-define(BAD_TRACES(Mod, Id, Request), [{class, hello}, {hello_request, hello_log:fmt_request(Request)}, 
                                       {hello_handler_callback, Mod}, {hello_service_id, Id}]).

-define(LOG_REQUEST_async_reply(CallbackModule, HandlerId, Request, Response),
    lager:info(?REQ_TRACES(CallbackModule, HandlerId, Request, Response), 
               "Hello handler with callback '~p' and service id '~p' answered async request.", 
               [CallbackModule, HandlerId])).

-define(LOG_REQUEST_request(CallbackModule, HandlerId, Request, Response, Time),
    lager:info(?REQ_TRACES(CallbackModule, HandlerId, Request, Response), 
               "Hello handler with callback '~p' and service id '~p' answered synced request in ~w ms.", 
               [CallbackModule, HandlerId, Time])).

-define(LOG_REQUEST_request_stop(CallbackModule, HandlerId, Request, Response, Reason, Time),
    lager:info(lists:append(?REQ_TRACES(CallbackModule, HandlerId, Request, Response), [{hello_error_reason, Reason}]), 
               "Hello handler with callback '~p' and service id '~p' answered request and stopped with reason ~w in ~w ms.", 
               [CallbackModule, HandlerId, Reason, Time])).

-define(LOG_REQUEST_request_no_reply(CallbackModule, HandlerId, Request, Time),
    lager:info(?REQ_TRACES(CallbackModule, HandlerId, Request),
               "Hello handler with callback '~p' and service id '~p' failed to answer request in ~w ms.", 
               [CallbackModule, HandlerId, Time])).

-define(LOG_REQUEST_request_stop_no_reply(CallbackModule, HandlerId, Request, Time),
    lager:info(?REQ_TRACES(CallbackModule, HandlerId, Request), 
               "Hello Handler with callback '~p' and service id '~p' failed to answer request and stopped with reason normal in ~w ms.", 
               [CallbackModule, HandlerId, Time])).

-define(LOG_REQUEST_request_stop_no_reply(CallbackModule, HandlerId, Request, Reason, Time),
    lager:info(lists:append(?REQ_TRACES(CallbackModule, HandlerId, Request), [{hello_error_reason, Reason}]), 
               "Hello handler with callback '~p' and service id '~p' failed to answer request and stopped with reason ~w in ~w ms.", 
               [CallbackModule, HandlerId, Reason, Time])).

-define(LOG_REQUEST_bad_request(CallbackModule, HandlerId, Request, Reason),
    lager:error(lists:append(?BAD_TRACES(CallbackModule, HandlerId, Request), [{hello_error_reason, Reason}]), 
                "Hello handler with callback '~p' and service id '~p' dismissed bad request.", 
                [CallbackModule, HandlerId])).

-define(LOG_WARNING_reason(CallbackModule, HandlerId, Msg, Args, Reason),
    lager:warning(  lists:append(?DEFAULT_TRACES,
                    [{hello_handler_callback, CallbackModule},
                    {hello_error_reason, Reason},
                    {hello_service_id, HandlerId}]),
                    Msg, Args)).

-define(PREP_SC(LogId, Msg), lists:append([element(2, LogId), " - ", Msg])).

-define(LOG_DEBUG(Msg, Args, Meta, LogId), lager:debug(?DEFAULT_META(Meta, LogId), ?PREP_SC(LogId, Msg), Args)).
-define(LOG_INFO(Msg, Args, Meta, LogId), lager:info(?DEFAULT_META(Meta, LogId), ?PREP_SC(LogId, Msg), Args)).
-define(LOG_NOTICE(Msg, Args, Meta, LogId), lager:notice(?DEFAULT_META(Meta, LogId), ?PREP_SC(LogId, Msg), Args)).
-define(LOG_WARNING(Msg, Args, Meta, LogId), lager:warning(?DEFAULT_META(Meta, LogId), ?PREP_SC(LogId, Msg), Args)).
-define(LOG_ERROR(Msg, Args, Meta, LogId), lager:error(?DEFAULT_META(Meta, LogId), ?PREP_SC(LogId, Msg), Args)).
-define(LOG_CRITICAL(Msg, Args, Meta, LogId), lager:critical(?DEFAULT_META(Meta, LogId), ?PREP_SC(LogId, Msg), Args)).
-define(LOG_ALERT(Msg, Args, Meta, LogId), lager:alert(?DEFAULT_META(Meta, LogId), ?PREP_SC(LogId, Msg), Args)).
-define(LOG_EMERGENCY(Msg, Args, Meta, LogId), lager:emergency(?DEFAULT_META(Meta, LogId), ?PREP_SC(LogId, Msg), Args)).

-endif.
