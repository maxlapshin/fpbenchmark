-module (element_submit).
-include_lib("nitrogen_core/include/wf.hrl").
-include ("records.hrl").
-compile(export_all).

reflectx() -> record_info(fields, submit).

render_element(Record) ->
    ID = Record#submit.id,
    Anchor = Record#submit.anchor,
    case Record#submit.postback of
        undefined -> ignore;
        Postback -> wf:wire(Anchor, #event { type=click, validation_group=ID, postback=Postback, delegate=Record#submit.delegate })
    end,

    Value = ["  ", wf:html_encode(Record#submit.text, Record#submit.html_encode), "  "],
    wf_tags:emit_tag(input, [
        {type, submit},
        {class, [button, Record#submit.class]},
        {style, Record#submit.style},
        {value, Value}
    ]).
