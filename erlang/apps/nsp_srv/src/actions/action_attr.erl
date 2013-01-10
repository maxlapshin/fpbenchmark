%% -*- mode: nitrogen -*-
-module (action_attr).
-compile (export_all).
-include_lib ("nitrogen_core/include/wf.hrl").
-include("../elements/records.hrl").

%% Move the following line to records.hrl:

render_action(Record) ->
    TargetPath = Record#attr.target,
    Attr = Record#attr.attr,
    Val = Record#attr.value,
    wf:f("jQuery(obj('~s')).attr('~s', '~s');", [TargetPath, Attr, Val]).
