-module (element_inplace_textbox1).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").
-include("loger.hrl").
-include("gettext.hrl").

reflect() -> record_info(fields, inplace_textbox1).

render_element(Record) ->
    % Get vars...
    OKButtonID = wf:temp_id(),
    CancelButtonID = wf:temp_id(),
    ViewPanelID = case Record#inplace_textbox1.vp_id of
        undefined -> wf:temp_id()
        ; VPID    -> VPID
    end,
    EditPanelID = case Record#inplace_textbox1.eb_id of
        undefined -> wf:temp_id()
        ; EPID    -> EPID
    end,
    LabelID = label_id(EditPanelID),
    TextBoxID = case Record#inplace_textbox1.tb_id of
        undefined -> wf:temp_id()
        ; TBID    -> TBID
    end,
    Tag = Record#inplace_textbox1.tag,
    OriginalText = Record#inplace_textbox1.text,
    Delegate = Record#inplace_textbox1.delegate,

    % Set up the events...
    Controls = {ViewPanelID, LabelID, EditPanelID, TextBoxID},
    OKEvent = #event { delegate=?MODULE, postback={ok, Delegate, Controls, Tag, {Record#inplace_textbox1.entry_id, Record#inplace_textbox1.feed_id}} },
    CancelEvent = #event { delegate=?MODULE, postback={cancel, Controls, Tag, OriginalText} },

    % Create the view...
    Text = Record#inplace_textbox1.text,
    Terms = #panel {
        class=[inplace_textbox, Record#inplace_textbox1.class],
        style=Record#inplace_textbox1.style,
        body = [
            #panel { id=ViewPanelID, class="entry-main-panel", body=[
                #panel { id=LabelID, class="entry-main-text", body=Text}
            ]},
            #panel { id=EditPanelID, class="edit", body=[
                #textbox { id=TextBoxID, text=Text, next=OKButtonID },
                " ",
                #link{id=OKButtonID, text=?_T("OK"), class="clr-4", url="javascript:void(0)",actions=OKEvent#event { type=click }},
                " ",
                #link{id=CancelButtonID, text=?_T("Cancel"), class="clr-4", url="javascript:void(0)",actions=CancelEvent#event { type=click }}
            ]}
        ]
    },

    case Record#inplace_textbox1.start_mode of
        view -> wf:wire(EditPanelID, #hide{});
        edit ->
            wf:wire(ViewPanelID, #hide{}),
            Script = #script { script="obj('me').focus(); obj('me').select();" },
            wf:wire(TextBoxID, Script)
    end,

    wf:wire(OKButtonID, TextBoxID, #validate { attach_to=CancelButtonID, validators=Record#inplace_textbox1.validators }),

    element_panel:render_element(Terms).

event({ok, Delegate, {ViewPanelID, LabelID, EditPanelID, TextBoxID}, Tag, {EntryID, FeedID}}) ->
    Value = wf:q(TextBoxID),
    Module = wf:coalesce([Delegate, wf:page_module()]),
    Value1 = Module:inplace_textbox_event(Tag, Value, {EntryID, FeedID}),
    ?INFO("  New value: ~p", [Value1]),
    wf:update(LabelID, Value1),
    wf:set(TextBoxID, Value1),
    wf:wire(EditPanelID, #hide {}),
    wf:wire(ViewPanelID, #show {}),
    ok;

event({cancel, {ViewPanelID, _LabelID, EditPanelID, TextBoxID}, _Tag, OriginalText}) ->
    wf:set(TextBoxID, OriginalText),
    wf:wire(EditPanelID, #hide {}),
    wf:wire(ViewPanelID, #show {}),
    ok;

event(_Tag) -> ok.


label_id(EditPanelID) ->
    EditPanelID ++ "_label".
