%% -*- mode: nitrogen -*-
-module (element_upload_flash).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").
-include_lib ("nitrogen_core/include/simple_bridge.hrl").

%% Move the following line to records.hrl:

reflect() -> record_info(fields, upload_flash).

render_element(Record = #upload_flash{}) ->
    %% Script = "jQuery(obj('~s')).uploadify({ ~n"
    %%     "'uploader'  : '/nitrogen/jquery.uploadify/uploadify.swf', ~n"
    %%     "'script'    : '/uploadify', ~n"
    %%     "'cancelImg' : '/nitrogen/jquery.uploadify/cancel.png', ~n"
    %%     "'folder'    : '/files/', ~n"
    %%     "'auto'      : true ~n"
    %%     "});~n",
    %% wf:wire(wf:f(Script, [Anchor])),

    %% element_panel:render_element(#panel{%% id=Record#upload_flash.id,
    %%                                     %% anchor=Anchor,
    %%                                     class=[Record#upload_flash.class],
    %%                                     style=Record#upload_flash.style,
    %%                                     body=[#upload{tag=blah}, #span{text="asd"}]
    %%                                    }).

    FinishedTag = {upload_finished, Record}, 
    PostbackInfo = wf_event:serialize_event_context(FinishedTag, Record#upload_flash.id, undefined, ?MODULE),

    TempId = wf:temp_id(),
    Script = "$('#~s').uploadify({ ~n"
        "'uploader'   : '/nitrogen/jquery.uploadify/uploadify.swf', ~n"
        "'script'     : '/~s', ~n"
        "'cancelImg'  : '/nitrogen/jquery.uploadify/cancel.png', ~n"
        "'folder'     : '/files/', ~n"
        "'scriptData' : {'eventContext':'~s'}, ~n"
        "'auto'       : true, ~n"
        "'onComplete' : function(event,ID, fileObj, response, data) {~n"
        "      alert('a'); alert(response); return true;" 
        "},~n"
        "'onSelect'   : function(event,ID,fileObj) { ~n"
        "      jQuery('#~s').uploadifySettings('scriptData', {'pageContext': Nitrogen.$params['pageContext']});~n"
        "}~n"
        "});~n",
    wf:wire(#attr{target=TempId, attr=id, value=TempId}),
    wf:wire(wf:f(Script, [TempId, wf:page_module(), PostbackInfo, TempId])),
    
    #panel{id=TempId}.


event({upload_finished, _Record}) ->
    %% wf_context:type(first_request),
    Req = wf_context:request_bridge(),

    %% Module = wf:page_module(),

    wf:wire("alert('test');"),
    io:format("~p~n", [Req:post_files()]),
    ok.
%% ,

%%     % % Create the postback...
%%     case Req:post_files() of
%%         [] -> 
%%             Module:finish_upload_event(Record#upload_flash.tag, undefined, undefined, undefined);
%%         [#uploaded_file { original_name=OriginalName, temp_file=TempFile }|_] ->
%%             Module:finish_upload_event(Record#upload_flash.tag, OriginalName, TempFile, node())
%%     end.
