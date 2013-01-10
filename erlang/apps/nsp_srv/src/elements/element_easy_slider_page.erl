%% -*- mode: nitrogen -*-
-module (element_easy_slider_page).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").

reflect() -> record_info(fields, easy_slider_page).

render_element(R = #easy_slider_page{}) ->
    wf_tags:emit_tag('li', [R#easy_slider_page.body],
                     [{class, [ R#easy_slider_page.class]},
                      {style, R#easy_slider_page.style}]).
