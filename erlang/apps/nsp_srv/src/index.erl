-module (index).
-compile(export_all).

-include_lib("nitrogen_core/include/wf.hrl").

-include("gettext.hrl").
-include("elements/records.hrl").
-include("setup.hrl").

main() -> #template { file=code:priv_dir(nsp_srv)++"/templates/idx.html"}.

title() -> "Kakaranet Okey".

body() ->
  #panel{class="slideshow-control", body=[
    #panel{class="page-content", body=[
    #list{class=switcher, body=[#listitem{body=#link{text=?_T(L)}} || L <- ["Gifts", "Tournaments", "Be Social!", "MatchMaker"]  ]},
    #list{class=pager, body=[
      #listitem{body=#link{class=prev, text="prev"}},
      #listitem{body=#link{class=next, text="next"}}
    ]}]}]}.

