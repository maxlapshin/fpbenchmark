%% -*- mode: nitrogen -*-
-module (element_dialog).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").

%% Move the following line to records.hrl:

reflect() -> record_info(fields, dialog).

render_element(Record = #dialog{anchor = Anchor, id = Id, class = Class, body = Body}) ->

    Script = "jQuery(obj('~s')).dialog({modal: true});",

    wf:wire(wf:f(Script, [Anchor])),
    element_panel:render_element(#panel{
                                    id=Id,
                                    anchor=Anchor,
                                    class=[Class],
                                    style=Record#dialog.style,
                                    body=Body
                                   }).
