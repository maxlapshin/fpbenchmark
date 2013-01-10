-module (element_form_hidden).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").

reflect() -> record_info(fields, form_hidden).

render_element(Record) ->
    Value = wf:html_encode(Record#form_hidden.text, Record#form_hidden.html_encode),
    wf_tags:emit_tag(input, [
        {class, Record#form_hidden.class},
        {type, hidden},
        {value, Value}
        | case Record#form_hidden.name of undefined -> []; N -> [{name, N}] end]).
