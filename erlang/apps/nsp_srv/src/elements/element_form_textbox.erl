-module(element_form_textbox).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").

reflect() -> record_info(fields, form_textbox).

render_element(Record) ->
    ID = Record#form_textbox.id,
    Anchor = Record#form_textbox.anchor,
    case Record#form_textbox.next of
        undefined -> ignore;
        Next ->
            Next1 = wf_render_actions:normalize_path(Next),
            wf:wire(Anchor, #event { type=enterkey, actions=wf:f("Nitrogen.$go_next('~s');", [Next1]) })
    end,

    case Record#form_textbox.postback of
        undefined -> ignore;
        Postback -> wf:wire(Anchor, #event { type=enterkey, postback=Postback, validation_group=ID, delegate=Record#form_textbox.delegate })
    end,

    Value = wf:html_encode(Record#form_textbox.text, Record#form_textbox.html_encode),
    Placeholder  = wf:html_encode(Record#form_textbox.placeholder, true),
    wf_tags:emit_tag(input, [
        {type, text},
        {class, [textbox, Record#form_textbox.class]},
        {style, Record#form_textbox.style},
        {placeholder, Placeholder},
        {value, Value},
        {size, Record#form_textbox.size},
        {maxlength, Record#form_textbox.maxlength}
    | case Record#form_textbox.name of undefined -> []; N -> [{name, N}] end]).
