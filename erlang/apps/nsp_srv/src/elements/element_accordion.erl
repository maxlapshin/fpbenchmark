%% -*- mode: nitrogen -*-
-module (element_accordion).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").

%% Move the following line to records.hrl:

reflect() -> record_info(fields, accordion).

render_element(Record = #accordion{anchor = Anchor, id = Id, class = Class, tab = Tab}) ->
    Script = "jQuery(obj('~s')).accordion()",

    wf:wire(wf:f(Script, [Anchor])),
    element_panel:render_element(#panel{
                                    id=Id,
                                    anchor=Anchor,
                                    class=[Class],
                                    style=Record#accordion.style,
                                    body=Tab
                                   }).
