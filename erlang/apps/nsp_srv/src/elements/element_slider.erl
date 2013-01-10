%% -*- mode: nitrogen -*-
-module (element_slider).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").


reflect() -> record_info(fields, slider).

render_element(Record = #slider{anchor = Anchor, id = Id, class = Class,
                               range = Range, min = Min, max = Max, values = Values,
                                value = Value}) ->
    Script = "jQuery(obj('~s')).slider({range: ~s, min: ~b, max: ~b, ~s, change: ~s~n",
    TextBoxIdMin = lists:concat([Id, "_values_min"]),
    TextBoxIdMax = lists:concat([Id, "_values_max"]),
    TextBoxId = lists:concat([Id, "_value"]),
    VMin = proplists:get_value(min, Values, 0),
    VMax = proplists:get_value(max, Values, 100),
    {Val, SlideFun, TextBox} =
        case Range of
            true ->
                AdditionalScript = case Record#slider.target of
                             false ->
                                 case Record#slider.postback of
                                     undefined ->
                                         "";
                                     {Module, Postback} ->
                                         site_utils:postback_to_js_string(Module, Postback)
                                 end;
                             T ->
                                 Text0 = Record#slider.text,
                                 Text = io_lib:fwrite(Text0, ["ui.values[0]", "ui.values[1]"]),
                                 io_lib:fwrite("$('.wfid_~s').text(~s);~n",
                                               [T, Text])
                         end,
                Val0 = io_lib:fwrite("values: [ ~b, ~b ]", [VMin, VMax]),
                SlideFun0 = io_lib:fwrite("\t   function( event, ui ) { ~n"
                                          "\t\t   $('~s').val(ui.values[0]); ~n"
                                          "\t\t   $('~s').val(ui.values[1]); ~n"
                                          "\t\t   if (event.originalEvent) {~s;}"
                                          "\t } ~n"
                                          "});", [TextBoxIdMin, TextBoxIdMax, AdditionalScript]),
                TextBox0 = [#textbox{id=TextBoxIdMin,
                                     style="display: none;",
                                     text=wf:to_list(VMin)},
                           #textbox{id=TextBoxIdMax,
                                    style="display: none;",
                                    text=wf:to_list(VMax)}],
                {Val0, SlideFun0, TextBox0};
            false ->
                Target = case Record#slider.target of
                             false ->
                                 "";
                             T ->
                                 Text0 = Record#slider.text,
                                 Text = io_lib:fwrite(Text0, ["ui.value"]),
                                 io_lib:fwrite("$('.wfid_~s').text(~s);~n",
                                               [T, Text])
                         end,
                Val0 = io_lib:fwrite("value: ~b", [Value]),
                SlideFun0 = io_lib:fwrite("\t   function( event, ui ) { ~n"
                                          "\t\t   $('~s').val(ui.value); ~n"
                                          "\t\t   ~s"
                                          "\t } ~n"
                                          "});", [TextBoxId, Target]),
                TextBox0 = [#textbox{id=TextBoxId,
                                     style="display: none;",
                                     text=wf:to_list(Value)}],
                {Val0, SlideFun0, TextBox0}
        end,

    wf:wire(wf:f(Script, [Anchor, Range, Min, Max, Val, SlideFun])),

    %% "$(\"#slider-range" ).slider({
    %%     		range: true,
    %%     		min: 0,
    %%     		max: 500,
    %%     		values: [ 75, 300 ],
    %%     		slide: function( event, ui ) {
    %%     			$( "#amount" ).val( "$" + ui.values[ 0 ] + " - $" + ui.values[ 1 ] );
    %%     		}
    %%
    [element_panel:render_element(#panel{
                                     id=Id,
                                     anchor=Anchor,
                                     class=[Class],
                                     style=Record#slider.style}),
     TextBox].
