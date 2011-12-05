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

% @private
-module(hello_supervisor).
-behaviour(supervisor).
-export([start_link/0]).
-export([init/1]).

-define(SERVER, hello_supervisor).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, {}).

init({}) ->
    Roles = case application:get_env(role) of
		{ok, client} -> [client];
		{ok, server} -> [server];
		{ok, Role} when is_list(Role) ->
		    Exess = lists:subtract(Role, [client, server]),
		    if
			length(Exess) > 0 -> error_logger:warning_report([{roles, ignored}, Exess]);
			true -> ok
		    end,
		    lists:subtract(Role, Exess);
		{ok, Role} ->
		    error_logger:warning_report([{roles, invalid}, Role]),
		    [client, server];
		undefined -> [client, server]
	    end,
    Children0 = case proplists:get_bool(client, Roles) of
		    true -> [{client_sup, {hello_client_sup, start_link, []},
			      transient, infinity, supervisor, [hello_client_sup]}];
		    _ -> []
		end,
    Children1 = case proplists:get_bool(server, Roles) of
		    true ->
			RegistrySpec    = {registry, {hello_registry, start_link, []}, transient, 1000, worker, [hello_registry]},
			ListenerSupSpec = {listener_sup, {hello_listener_supervisor, start_link, []},
					   transient, infinity, supervisor, [hello_listener_supervisor]},
			BindingSupSpec  = {binding_sup, {hello_binding_supervisor, start_link, []},
					   transient, infinity, supervisor, [hello_binding_supervisor]},
			[RegistrySpec, ListenerSupSpec, BindingSupSpec|Children0];
		    _ ->
			Children0
		end,
    RestartStrategy = {one_for_one, 5, 10},
    {ok, {RestartStrategy, Children1}}.
