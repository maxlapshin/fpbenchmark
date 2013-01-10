%% -*- mode: nitrogen -*-
-module (element_accordion_tab).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").

%% Move the following line to records.hrl:

reflect() -> record_info(fields, accordion_tab).

render_element(_Record = #accordion_tab{title = Title, body = Body}) ->
    SourceTop = "\t<h3><a href=\"#\">~s</a></h3>~n"
        "\t<div>~n",    
    SourceBottom = "\t</div>~n",

    Top = io_lib:fwrite(SourceTop, [Title]),
    Bottom = io_lib:fwrite(SourceBottom, []),
    [Top, Body, Bottom].
    

