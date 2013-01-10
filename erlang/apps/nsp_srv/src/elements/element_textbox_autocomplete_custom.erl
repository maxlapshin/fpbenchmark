%% @author baranoff.vladimir@gmail.com
%% Overriden textbox_autocomplete

%PUBLIC BETA this has one problem. When user clicks very fast on a option list, when it is just rendered, no select event happens.

-module (element_textbox_autocomplete_custom).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").

reflect() -> record_info(fields, textbox_autocomplete_custom).

render_element(Record) ->
    % Get properties...
    Delegate = Record#textbox_autocomplete_custom.delegate,
    Tag = Record#textbox_autocomplete_custom.tag,
    Anchor = Record#textbox_autocomplete_custom.anchor,
    AutoCompleteMinLength = Record#textbox_autocomplete_custom.minLength,
    AutoCompleteDelay = Record#textbox_autocomplete_custom.delay,

    % Write out the script to make this element autocompletable...
    AutoCompleteEnterPostbackInfo = wf_event:serialize_event_context({autocomplete_enter_event, Delegate, Tag}, Anchor, undefined, ?MODULE),
    AutoCompleteSelectPostbackInfo = wf_event:serialize_event_context({autocomplete_select_event, Delegate, Tag }, Anchor, undefined, ?MODULE ),

    AutoCompleteOptions = {struct, [
        {dataType, <<"json">>},
        {minLength, AutoCompleteMinLength},
        {delay, AutoCompleteDelay}
    ]},

    AutoCompleteScript = #script {
        script = wf:f("Nitrogen.$autocomplete_custom('~s', ~s, '~s', '~s');", [
          Anchor,
          mochijson2:encode(AutoCompleteOptions),
          AutoCompleteEnterPostbackInfo,
          AutoCompleteSelectPostbackInfo
        ])
    },
    wf:wire(AutoCompleteScript),

    % Render as a textbox.
    Value = wf:html_encode(Record#textbox_autocomplete_custom.text, Record#textbox_autocomplete_custom.html_encode),
    wf_tags:emit_tag(input, [
        {type, text},
        {class, [textbox_autocomplete, Record#textbox_autocomplete_custom.class]},
        {style, Record#textbox_autocomplete_custom.style},
        {value, Value}
    ]).

event({autocomplete_select_event, Delegate, SelectTag})->
    SelectItem = mochijson2:decode(wf:q(select_item)),
    Module = wf:coalesce([Delegate, wf:page_module()]),
    Module:autocomplete_select_event(SelectItem, SelectTag);

event({autocomplete_enter_event, Delegate, EnterTag})->
    SearchTerm = wf:q(search_term),
    wf_context:type(first_request),
    wf:content_type("application/json"),
    Module = wf:coalesce([Delegate, wf:page_module()]),
    wf_context:data([
      Module:autocomplete_enter_event(SearchTerm, EnterTag)
    ]).
