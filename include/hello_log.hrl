-ifndef(HELLO_LOG).
-define(HELLO_LOG, 1).

-include("hello.hrl").
-include("hello_log_ids.hrl").

-define(DEFAULT_TRACES, [{class, hello}]).
-define(DEFAULT_META(Meta, LogId), 
        lists:append([[{status_code, element(1, LogId)}, {message_id, element(2, LogId)}], Meta, ?DEFAULT_TRACES])).
-define(REQ_TRACES(Mod, Method), [{class, hello}, {hello_request, api}, {hello_handler, Mod}, {hello_method, Method}]).
-define(BAD_TRACES(Mod, Method), [{class, hello}, {hello_request, error}, {hello_handler, Mod}, {hello_method, Method}]).

-define(LOG_REQUEST_async_reply(CallbackModule, HandlerPid, Request, Response),
    lager:info(?REQ_TRACES(CallbackModule, Request#request.method), 
               "async reply on ~w. ~s - ~s", 
               [HandlerPid, hello_log:fmt_request(Request), hello_log:fmt_response(Response)])).

-define(LOG_REQUEST_request(CallbackModule, HandlerPid, Request, Response, Time),
    lager:info(?REQ_TRACES(CallbackModule, Request#request.method), 
               "request on ~w. ~s - ~s (~w ms)", 
               [HandlerPid, hello_log:fmt_request(Request), hello_log:fmt_response(Response), Time])).

-define(LOG_REQUEST_request_stop(CallbackModule, HandlerPid, Request, Response, Reason, Time),
    lager:info(?REQ_TRACES(CallbackModule, Request#request.method), 
               "request on ~w. ~s - ~s (stopped with reason ~w) (~w ms)", 
               [HandlerPid, hello_log:fmt_request(Request), hello_log:fmt_response(Response), Reason, Time])).

-define(LOG_REQUEST_request_no_reply(CallbackModule, HandlerPid, Request, Time),
    lager:info(?REQ_TRACES(CallbackModule, Request#request.method),
               "request on ~w. ~s - noreply (~w ms)", 
               [HandlerPid, hello_log:fmt_request(Request), Time])).

-define(LOG_REQUEST_request_stop_no_reply(CallbackModule, HandlerPid, Request, Time),
    lager:info(?REQ_TRACES(CallbackModule, Request#request.method), 
               "request on ~w. ~s (stopped with reason normal) (~w ms)", 
               [HandlerPid, hello_log:fmt_request(Request), Time])).

-define(LOG_REQUEST_request_stop_no_reply(CallbackModule, HandlerPid, Request, Reason, Time),
    lager:info(?REQ_TRACES(CallbackModule, Request#request.method), 
               "request on ~w. ~s (stopped with reason ~w) (~w ms)", 
               [HandlerPid, hello_log:fmt_request(Request), Reason, Time])).

-define(LOG_REQUEST_bad_request(CallbackModule, HandlerPid, Request, Reason),
    lager:error(?BAD_TRACES(CallbackModule, Request#request.method), 
                "bad request on ~w. ~s - ~w", 
                [HandlerPid, hello_log:fmt_request(Request), Reason])).

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
