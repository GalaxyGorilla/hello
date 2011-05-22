% Copyright (c) 2010-2011 by Travelping GmbH <info@travelping.com>

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

-module(tpjrpc_example_service).
-behaviour(tp_json_rpc_service).

-export([register_yourself/0]).
-export([handle_request/3, param_info/1, method_info/0]).
-include_lib("tp_json_rpc/include/tp_json_rpc.hrl").

register_yourself() -> tp_json_rpc_service:register(example, ?MODULE).

method_info() ->
    [#rpc_method{name        = echo,
                 description = "return the given string"},
     #rpc_method{name        = append,
                 description = "append the given strings"},
     #rpc_method{name        = enum_test,
                 description = "test tp_json_rpc's support for enums"},
     #rpc_method{name        = return_error,
                 description = "always returns an error reply"}].

param_info(echo) ->
    [#rpc_param{name = text,
                type = string,
                description = "the text to be echoed"}];
param_info(append) ->
    [#rpc_param{name = str1,
                type = string,
                optional = true,
                default  = <<"">>},
     #rpc_param{name = str2,
                type = string,
                optional = true,
                default  = <<"">>}];
param_info(enum_test) ->
    [#rpc_param{name = atom,
                type = {enum, [a, b, c]},
                description = "the atom to be echoed, \"a\", \"b\", or \"c\""}];
param_info(return_error) ->
    [#rpc_param{name = code,
                type = integer},
     #rpc_param{name = message,
                type = string,
                optional = true,
                default  = <<"">>}].

handle_request(_Req, echo, [Str]) ->
    {ok, Str};
handle_request(_Req, append, [Str1, Str2]) ->
    {ok, <<Str1/binary, Str2/binary>>};
handle_request(_Req, enum_test, [Atom]) ->
    {ok, Atom};
handle_request(_Req, return_error, [Code, Message]) ->
    {error, Code, Message}.
