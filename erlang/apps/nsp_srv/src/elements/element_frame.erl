%% -*- mode: nitrogen -*-
-module (element_frame).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").


reflect() -> record_info(fields, frame).

render_element(R = #frame{}) ->
    HideButton =
        case R#frame.close_action of
            undefined ->
                #hr{style="margin: 5px;"};
            _ ->
                Event = #event{type=click,
                               actions=#hide{effect=blind,
                                             target=R#frame.close_action}},
                [#p{body=#image{image=R#frame.close_icon},
                   style="position: relative; text-align: right; margin-right: 10px;",
                   actions=Event},
                 #hr{style="margin: 5px;"}]
        end,
            [
     #panel {style="width: 100%; margin: 0px;",
             body=[case R#frame.icon of
                       undefined ->
                           [];
                       _ ->
                           #panel { body=#image{image=R#frame.icon},
                                    style="float: left; margin: 10px; margin-top: -5px;"}
                   end,
                   #panel { body=[#panel{body=[#h1{text=R#frame.title}],
                                         style="float: left; margin: 5px;"},
                                  #panel{body=[HideButton],
                                         style="padding-top: 0px;"}],
                            style="margin-top: 10px; text-align:left;"},
                   #panel {body=R#frame.body}]}
    ].
