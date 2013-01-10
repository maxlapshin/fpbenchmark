
-module (element_lightbox_link).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").
-compile(export_all).

reflect() -> record_info(fields, lightbox_link).

render_element(Record) ->
    Body =  Record#lightbox_link.body,
    Id = Record#lightbox_link.id,

    Rel = case Record#lightbox_link.gallery of
        undefined ->
            "prettyPhoto";
        GalleryName ->
            lists:concat(["prettyPhoto[", GalleryName, "]"])
    end,
    %% TODO: optimize here
    Script = #script{ script = "jQuery(\"a[rel^='prettyPhoto']\").prettyPhoto({social_tools: false, overlay_gallery: false});"},
    %% this solution not work with galleries yet but it is more efficient
    %Script = #script { script="jQuery(obj('me')).prettyPhoto({social_tools: false, overlay_gallery: false});" },
    wf:wire(Id, Script),

    wf_tags:emit_tag(a, Body, [
        {href, Record#lightbox_link.url},
        {rel, Rel},
        {class, [lightbox_link, Record#lightbox_link.class]},
        {title, wf:html_encode(Record#lightbox_link.title, Record#lightbox_link.html_encode)}
    ]).
