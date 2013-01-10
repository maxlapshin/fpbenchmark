%% -*- mode: nitrogen -*-
-module (element_easy_slider).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").

reflect() -> record_info(fields, easy_slider).

render_element(R = #easy_slider{}) ->
    JS = "$(document).ready(function(){~n"

        "~njQuery(objs('~s')).easySlider({~n"
        "controlsShow: false,~n"
        "auto: true,~n"
        "pause: 3500,~n"
        "continuous: true~n"
        "});~n"
        "});",
    wf:wire(wf:f(JS,[R#easy_slider.anchor])),
    Body = wf_tags:emit_tag('ul', R#easy_slider.pages, []),
    #panel{anchor = R#easy_slider.anchor, body = Body, class = [slider, R#easy_slider.class]}.


    

        
