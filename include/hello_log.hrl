-ifndef(HELLO_LOG).
-define(HELLO_LOG, 1).

-include("hello.hrl").
-include("hello_log_ids.hrl").

-define(DEFAULT_TRACES, [{class, hello}]).
-define(DEFAULT_META(Meta, LogId), 
        lists:append([[{status_code, element(2, LogId)}, {message_id, element(1, LogId)}], Meta, ?DEFAULT_TRACES])).

%% hello_handler specific log macros
-define(REQ_TRACES(Mod, HandlerId, Request, Response, LogId), 
        lists:append([?REQ_TRACES(Mod, HandlerId, Request, LogId), 
                        [{hello_response, hello_log:fmt_response(Response)}] 
                     ])).

-define(REQ_TRACES(Mod, HandlerId, Request, LogId), 
        ?DEFAULT_META([ {hello_request, hello_log:fmt_request(Request)}, 
                        {hello_service_id, HandlerId},
                        {hello_handler_callback, Mod}], LogId)).

-define(LOG_REQUEST_async_reply(CallbackModule, HandlerId, Request, Response, LogId),
    lager:debug(?REQ_TRACES(CallbackModule, HandlerId, Request, Response, LogId), 
               ?PREP_SC(LogId, "Hello handler with callback '~p' and service id '~p' answered async request."), 
               [CallbackModule, HandlerId])).

-define(LOG_REQUEST_request(CallbackModule, HandlerId, Request, Response, Time, LogId),
    lager:debug(?REQ_TRACES(CallbackModule, HandlerId, Request, Response, LogId), 
               ?PREP_SC(LogId, "Hello handler with callback '~p' and service id '~p' answered synced request in '~w' ms."), 
               [CallbackModule, HandlerId, Time])).

-define(LOG_REQUEST_request_stop(CallbackModule, HandlerId, Request, Response, Reason, Time, LogId),
    lager:info(lists:append(?REQ_TRACES(CallbackModule, HandlerId, Request, Response, LogId), [{hello_error_reason, Reason}]), 
               ?PREP_SC(LogId, "Hello handler with callback '~p' and service id '~p' answered request and stopped with reason ~w in ~w ms."), 
               [CallbackModule, HandlerId, Reason, Time])).

-define(LOG_REQUEST_request_no_reply(CallbackModule, HandlerId, Request, Time, LogId),
    lager:debug(?REQ_TRACES(CallbackModule, HandlerId, Request, LogId),
               ?PREP_SC(LogId, "Hello handler with callback '~p' and service id '~p' failed to answer request in ~w ms."), 
               [CallbackModule, HandlerId, Time])).

-define(LOG_REQUEST_request_stop_no_reply(CallbackModule, HandlerId, Request, Time, LogId),
    lager:info(?REQ_TRACES(CallbackModule, HandlerId, Request, LogId), 
               ?PREP_SC(LogId, "Hello Handler with callback '~p' and service id '~p' failed to answer request and stopped with reason normal in ~w ms."), 
               [CallbackModule, HandlerId, Time])).

-define(LOG_REQUEST_request_stop_no_reply(CallbackModule, HandlerId, Request, Reason, Time, LogId),
    lager:info(lists:append(?REQ_TRACES(CallbackModule, HandlerId, Request, LogId), [{hello_error_reason, Reason}]), 
               ?PREP_SC(LogId, "Hello handler with callback '~p' and service id '~p' failed to answer request and stopped with reason ~w in ~w ms."), 
               [CallbackModule, HandlerId, Reason, Time])).

-define(LOG_REQUEST_bad_request(CallbackModule, HandlerId, Request, Reason, LogId),
    lager:info(lists:append(?REQ_TRACES(CallbackModule, HandlerId, Request, LogId), [{hello_error_reason, Reason}]), 
                ?PREP_SC(LogId, "Hello handler with callback '~p' and service id '~p' dismissed bad request."), 
                [CallbackModule, HandlerId])).

-define(LOG_WARNING_reason(CallbackModule, HandlerId, Msg, Args, Reason, LogId),
    lager:info( ?DEFAULT_META( [ {hello_handler_callback, CallbackModule},
                                    {hello_error_reason, Reason},
                                    {hello_service_id, HandlerId}
                                    ], LogId)),
                                    Msg, Args).

%% Generic 
-define(PREP_SC(LogId, Msg), lists:append([integer_to_list(element(2, LogId)), " - ", Msg])).

-define(LOG_DEBUG(Msg, Args, Meta, LogId), lager:debug(?DEFAULT_META(Meta, LogId), ?PREP_SC(LogId, Msg), Args)).
-define(LOG_INFO(Msg, Args, Meta, LogId), lager:info(?DEFAULT_META(Meta, LogId), ?PREP_SC(LogId, Msg), Args)).
-define(LOG_NOTICE(Msg, Args, Meta, LogId), lager:notice(?DEFAULT_META(Meta, LogId), ?PREP_SC(LogId, Msg), Args)).
-define(LOG_WARNING(Msg, Args, Meta, LogId), lager:warning(?DEFAULT_META(Meta, LogId), ?PREP_SC(LogId, Msg), Args)).
-define(LOG_ERROR(Msg, Args, Meta, LogId), lager:error(?DEFAULT_META(Meta, LogId), ?PREP_SC(LogId, Msg), Args)).
-define(LOG_CRITICAL(Msg, Args, Meta, LogId), lager:critical(?DEFAULT_META(Meta, LogId), ?PREP_SC(LogId, Msg), Args)).
-define(LOG_ALERT(Msg, Args, Meta, LogId), lager:alert(?DEFAULT_META(Meta, LogId), ?PREP_SC(LogId, Msg), Args)).
-define(LOG_EMERGENCY(Msg, Args, Meta, LogId), lager:emergency(?DEFAULT_META(Meta, LogId), ?PREP_SC(LogId, Msg), Args)).

-endif.
