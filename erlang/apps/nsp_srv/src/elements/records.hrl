-record(frame, {?ELEMENT_BASE(element_frame), icon=undefined, close_icon="", title="",
                close_action=undefined, body=[]}).

-record(view_entry, {?ELEMENT_BASE(element_view_entry), entry}).

-record(view_system_entry, {?ELEMENT_BASE(element_view_system_entry), entry, type}).

-record(view_comment, {?ELEMENT_BASE(element_view_comment), comment}).

-record(accordion, {?ELEMENT_BASE(element_accordion), tab}).

-record(accordion_tab, {?ELEMENT_BASE(element_accordion_tab), title, body}).

-record(draggable_new, {?ELEMENT_BASE(element_draggable_new), tag, body=[], group, handle,
                        clone=true, revert=true, scroll=true, container = false, zindex = false,
                        group_disable=[], criteria_for=[], disabled=false}).

-record(slider, {?ELEMENT_BASE(element_slider), range = false, min = 0, max = 100, postback = undefined,
                 value = 20, values = [{min,20}, {max,50}], target=false, text="~s +' - '+ ~s"}).

-record(dialog, {?ELEMENT_BASE(element_dialog), body=[]}).

-record(attr, {?ACTION_BASE(action_attr), attr, value}).

-record(view_media, {?ELEMENT_BASE(element_view_media), media, target, fid=0, cid=0, only_thumb}).

-record(lightbox_link, {?ELEMENT_BASE(element_lightbox_link), url="javascript:", gallery, body=[], title="", html_encode=true}).

-record(tooltip_wizard, {?ACTION_BASE(action_tooltip_wizard), content, title="", my, at, options="{}"}).
-record(tooltip_wizard_update, {?ACTION_BASE(action_tooltip_wizard_update)}).

-record(upload_flash, {?ELEMENT_BASE(element_upload_flash), tag}).

-record(easy_slider, {?ELEMENT_BASE(element_easy_slider), pages = []}).

-record(easy_slider_page, {?ELEMENT_BASE(element_easy_slider_page), body = []}).

-record(register, {?ELEMENT_BASE(element_register), action}).

-record(show_lightbox, {?ELEMENT_BASE(element_show_lightbox), action}).

%%% copy of element_button + element_link
-record(cool_button, {?ELEMENT_BASE(element_cool_button), url=undefined, title = "", text="Button", html_encode=true, postback, delegate}).

-record(span_b, {?ELEMENT_BASE(element_span_b), body = []}).

-record(tabs, {?ELEMENT_BASE(element_tabs), tabs = []}).

-record(form, {?ELEMENT_BASE(element_form), body = [], action="", method="POST"}).

-record(flashm, {?ELEMENT_BASE(element_flashm)}).

-record(submit, {?ELEMENT_BASE(element_submit), text="Submit", html_encode=true, postback, delegate}).

%% elements with "form_" prefix used for direct posting of the form. They has
%% name attribute.
-record(form_textbox, {?ELEMENT_BASE(element_form_textbox), text="", placeholder="", html_encode=true, next, postback, delegate, name, size="", maxlength=""}).

-record(form_hidden, {?ELEMENT_BASE(element_form_hidden), text="", html_encode=true, name}).

-record(form_dropdown, {?ELEMENT_BASE(element_form_dropdown), options=[], html_encode=true, postback, delegate, value, name}).


%% notification boxes, type = info | error | success | message | system_message
%% postition = top | left | right
%% short = true | false - with or without funny guy
-record(notice, {?ELEMENT_BASE(element_notice), delay, position=left, is_short=true, type=info, title="", body=[]}).

% admin panel grids
-record(packages_grid, {?ELEMENT_BASE(element_packages_grid), data = []}).
-record(purchases_grid, {?ELEMENT_BASE(element_purchases_grid), data = []}).

-record(inplace_textbox1, {?ELEMENT_BASE(element_inplace_textbox1), tag, text="",
                           entry_id=indefined, feed_id=undefined, eb_id=undefined, tb_id=undefined, vp_id=undefined,
                           html_encode=true, start_mode=view, validators=[], delegate=undefined}).


-record(textbox_autocomplete_custom, {?ELEMENT_BASE(element_textbox_autocomplete_custom), tag, text="", minLength=2, delay=300, html_encode=true, next, postback, delegate=undefined }).
