%%----------------------------------------------------------------------
%% @author JLarky <jlarky@gmail.com>
%% @copyright Paynet Internet ve Bilisim Hizmetleri A.S. All Rights Reserved.
%% @doc
%% Code to create tooltip_wizard for create_game.erl
%% @end
%%----------------------------------------------------------------------
-module (action_tooltip_wizard).
-compile (export_all).
-include_lib ("nitrogen_core/include/wf.hrl").
-include("../elements/records.hrl").



render_action(Record) ->
    #tooltip_wizard{target = Target, title = Title, content = Content, options = Options, my = My, at = At} = Record,
    Id = wf:temp_id(),
    MY = case My of
	     undefined -> "bottom left";
	     _ -> My
	 end,
    AT = case At of
	     undefined -> "top center";
	     _ -> At
	 end,
    Script = "jQuery(objs('~s').qtip($.extend(true, {}, ~s, ~s)));",
    DefaultOptions = wf:f("{content:{text:'~s', title: {text:'~s',button:true}}, show:false, hide:false,"
			  "position:{at:'~s', my:'~s'}, id:'~s', prerender: true,"
			  "events:{hide:qtip_wizard.hide_event, render:qtip_wizard.update_tooltip} }",
			  [Content, Title, AT, MY, Id]),
    [
     wf:f("qtip_wizard.add_new('~s','~s');", [Id, Target]),
     wf:f(Script, [Target, DefaultOptions, Options])
    ].
