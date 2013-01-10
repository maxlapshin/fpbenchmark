%% -*- mode: nitrogen -*-
-module (action_tooltip_wizard_update).
-compile (export_all).
-include_lib ("nitrogen_core/include/wf.hrl").
-include("../elements/records.hrl").

render_action(_Record) ->
    [
     wf:f("qtip_wizard.update_tooltip();")
    ].
