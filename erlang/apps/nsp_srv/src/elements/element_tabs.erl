%% -*- mode: nitrogen -*-
-module (element_tabs).

%% Example usage:
%% wf:wire("objs('tabs').tabs()"),
%% #tabs{id=tabs,
%%       tabs = [
%% 	      {?_T("Tab 1"), "1"},
%% 	      {?_T("Tab 2"), "2"}
%% 	     ]}.

-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").

reflect() -> record_info(fields, tabs).

render_element(#tabs{tabs = Tabs}) ->

    List = [ begin {I, B} = lists:nth(N, Tabs), {"tab_" ++ integer_to_list(N), I, B} end || N <- lists:seq(1, length(Tabs))],

    HeadersList = [ #listitem{body=#link{url="#"++ID, text=Title, postback={tab_selected, ID}}} || {ID, Title, _Body} <- List ],
    TabsList    = [ ["<div id=\""++ID++"\" class=\"tabcontent\">",Body,"</div>"] || {ID, _Ttile, Body} <- List ],
    ["<div id=\"tabs-block\" class=\"wfid_tabs\">",
     #panel{class="tab-headers-wrapper", body=#list{class=tabset, body=HeadersList}},
     #panel{class="tabs-wrapper tabarea", body=TabsList},
     "</div>"
    ].
