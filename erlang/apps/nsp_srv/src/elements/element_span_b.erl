%% -*- mode: nitrogen -*-
-module (element_span_b).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").

reflect() -> record_info(fields, span_b).

render_element(R=#span_b{}) ->
    ID = case re:run(R#span_b.id, "^.wfid_(.+)$") of
	{match,[_,{B,L}]} -> string:substr(R#span_b.id, B+1, L)
	;_ -> R#span_b.id
    end,
    wf_tags:emit_tag('span', [R#span_b.body],
                     [{class, [ R#span_b.class]},
                      {style, R#span_b.style},
		      {id, ID}]).


