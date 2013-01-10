% JLarky, 2011
% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.
%% @doc

%% This module generates fancy thing that must be button or link (if
%% url is defined than it's link) which have some image as background.


-module (element_cool_button).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").
-compile(export_all).

reflect() -> record_info(fields, cool_button).

render_element(Record) ->
    #cool_button{id=Id, anchor=Anchor, actions=_IgnoreActions, % Actions already applyed
		 show_if=Show_if, class=OrigClass, style=Style, url=Url,
		 text=Text, title=Title, html_encode=Html_encode,
		 postback=Postback, delegate=Delegate} = Record,
    Actions = undefined,
    Body = "",
    Class=["cool-button", OrigClass],

    Button = #button{id=Id, anchor=Anchor, actions=Actions,
		     show_if=Show_if, class=Class, style=Style,
		     text=Text, html_encode=Html_encode,
		     postback=Postback, delegate=Delegate},

    Link = #link{id=Id, anchor=Anchor, actions=Actions,
		 show_if=Show_if, class=Class, style=Style,
		 title=Title, text=Text, body=Body,
		 html_encode=Html_encode, url=Url, postback=Postback,
		 delegate=Delegate},

    Element = case Url of
		  undefined -> Button;
		  _ -> Link
	      end,
    #panel{class="cool-button-wrapper", body=Element}.

test() ->
    ok.
