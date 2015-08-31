% Copyright (c) 2010-2015 by Travelping GmbH <info@travelping.com>

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

% @private
-module(hello_log).

-export([fmt_response/1, fmt_request/1]).

-include("hello.hrl").

%% --------------------------------------------------------------------------------
%% -- Formaters for hello_handler
fmt_request(#request{method = Method, args = Params}) ->
	lists:append(["METHOD: '", binary_to_list(Method), 
				  "'; ARGS: '", lists:flatten(io_lib:format("~p", [Params]))
				 ]).
    %<<"method: ", (hello_json:encode(Method))/binary, ", params: ", (hello_json:encode(Params))/binary>>.

fmt_response(ignore) -> ["ignored"];
fmt_response({ok, Response}) -> lists:flatten(io_lib:format("~p", [Response]));
fmt_response(Result) -> lists:flatten(io_lib:format("~4096p", [Result])).
