-module (element_form_dropdown).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").


reflect() -> record_info(fields, form_dropdown).

render_element(Record) ->
    ID = Record#form_dropdown.id,
    Anchor = Record#form_dropdown.anchor,
    case Record#form_dropdown.postback of
        undefined -> ignore;
        Postback -> wf:wire(Anchor, #event { type=change, postback=Postback, validation_group=ID, delegate=Record#form_dropdown.delegate })
    end,

    case Record#form_dropdown.value of
        undefined -> ok;
        Value -> wf:set(Anchor, Value)
    end,

    Options=case Record#form_dropdown.options of
        undefined -> "";
        L -> [create_option(X, Record#form_dropdown.html_encode) || X <- L]
    end,

    wf_tags:emit_tag(select, Options, [
        {class, [dropdown, Record#form_dropdown.class]},
        {style, Record#form_dropdown.style}
        | case Record#form_dropdown.name of undefined -> []; N -> [{name, N}] end]).

create_option(X, HtmlEncode) ->
    SelectedOrNot = case X#option.selected of
        true -> selected;
        _ -> not_selected
    end,

    Content = wf:html_encode(X#option.text, HtmlEncode),
    Value = wf:html_encode(X#option.value, HtmlEncode),
    wf_tags:emit_tag(option, Content, [
        {value, Value},
        {SelectedOrNot, true}
    ]).
