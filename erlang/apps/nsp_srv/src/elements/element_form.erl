%% -*- mode: nitrogen -*-
-module (element_form).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").

reflect() -> record_info(fields, form).

render_element(R=#form{}) ->
    ID = case re:run(R#form.id, "^.wfid_(.+)$") of
	{match,[_,{B,L}]} -> string:substr(R#form.id, B+1, L)
	;_ -> R#form.id
    end,
    wf_tags:emit_tag('form', [R#form.body], [
        {class, [R#form.class]},
        {action, R#form.action},
        {style, R#form.style},
        {method, R#form.method},
        {id, ID}]).


