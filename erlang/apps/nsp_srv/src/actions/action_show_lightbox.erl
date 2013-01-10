%% -*- mode: nitrogen -*-
-module (action_show_lightbox).
-compile (export_all).
-include_lib ("nitrogen_core/include/wf.hrl").
-include("../elements/records.hrl").
-include("gettext.hrl").

render_action(#show_lightbox{action=Action0}) ->
    Action = case Action0 /= undefined of
                 true -> Action0;
                 false -> wf:to_atom(wf:q(action))
             end,
    case Action of
        register ->
            register();
        "facebook-register" ->
            facebook_register();
        "login" ->
            login();
        "facebook-login" -> [];
        _ -> []

    end.
    %% case webutils:show_splash() of
    %%     false -> "";
    %%     true -> [webutils:splash_lightbox()]
    %% end,



register() ->
    %% case invite:get_invite_code() of
    %%     {ok, _Invite} ->
    %% wf:update(lightbox_content, #register{}),
    wf:wire("alert('a');"),
    #show{target=lightbox}.
    %%     _error_or_undefined ->
    %%         event({error, ?_T("Invalid invitation code")})
    %% end.

facebook_register() ->
    case invite:get_invite() of
        {ok, _Invite} ->
            register();
        _error_or_undefined ->
            event({error, ?_T("Invalid invitation code")})
    end.

login() ->
    #show{target=login_lightbox}.



event(Other) ->
    webutils:event(Other).
