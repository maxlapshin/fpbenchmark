% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (element_draggable_new).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").
-compile(export_all).

reflect() -> record_info(fields, draggable_new).

render_element(Record) -> 
    % Get properties...
    Anchor = Record#draggable_new.anchor,
    Tag = {Record#draggable_new.tag, 
           Record#draggable_new.id,
           Record#draggable_new.body,
           Record#draggable_new.group_disable,
	   Record#draggable_new.criteria_for
	  },
    PickledTag = wf:pickle(Tag),	
    GroupClasses = groups_to_classes(Record#draggable_new.group),

    Handle = case Record#draggable_new.handle of
        undefined -> "null";
        Other2 -> wf:f("'.~s'", [Other2])
    end,

    Helper = case Record#draggable_new.clone of
        true -> clone;
        false -> original
    end,

    Revert = case Record#draggable_new.revert of
        true -> "true";
        false -> "false";
        valid -> "'valid'";
        invalid -> "'invalid'"
    end,

    Container = case Record#draggable_new.container of
                    false -> false;
                    window -> "'window'";
                    parent -> "'parent'";
                    document -> "'document'";
                    V -> V
                end,
    Disable = case Record#draggable_new.disabled of
                  true ->
                      true;
                  _ ->
                      false
              end,
    
    Class = case Record#draggable_new.disabled of
                true ->
                    [draggable_new, GroupClasses, Record#draggable_new.class, 'ui-state-disabled'];
                _ ->
                    [draggable_new, GroupClasses, Record#draggable_new.class]
        end,
    
    % Write out the script to make this element draggable_new...
    Script = wf:f(
               "Nitrogen.$draggable('~s', { opacity: 0.5, cursor: 'crosshair', snap: '.create_game_criteria_box', disabled: ~s,  handle: ~s, helper: '~s', revert: ~s, scroll: ~s, containment: ~s, zIndex: ~p, appendTo: 'body' }, '~s');",
               [
                Anchor,
                Disable,
                Handle,
                Helper, 
                Revert, 
                Record#draggable_new.scroll,
                Container,
		Record#draggable_new.zindex,
		PickledTag
               ]),
    wf:wire(Script),

    % Render as a panel...
    element_panel:render_element(#panel {
        id=Record#draggable_new.id,
        anchor=Anchor,
                                    
        class=Class,
        style=Record#draggable_new.style,
        body=Record#draggable_new.body
    }).

groups_to_classes([]) -> "";
groups_to_classes(undefined) -> "";
groups_to_classes(Groups) ->
    Groups1 = lists:flatten([Groups]),
    Groups2 = ["drag_group_" ++ wf:to_list(X) || X <- Groups1],
    string:join(Groups2, " ").

