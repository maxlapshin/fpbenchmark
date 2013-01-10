%-define(APPSERVER_NODE, nsx_opt:get_env(nsp_srv,app_srv_node, 'app@rigdzin.cc')).
%-define(GAMESRVR_NODE, nsx_opt:get_env(nsp_srv,game_srv_node, 'game@rigdzin.cc')).
-define(GAMEHOST, nsx_opt:get_env(nsp_srv,game_srv_host, '127.0.1.1')).
-define(FORGET_TOKEN_EXPIRED, 86400).
-define(INVITE_CODE_EXPIRED, 172800). %% 48h
-define(SERVER_PORT, nsx_opt:get_env(nsp_srv,game_srv_port, 7999)).
-define(SERVER_HOST, nsx_opt:get_env(nsp_srv, game_srv_host, "kakaranet.com")).
-define(HTTP_ADDRESS, nsx_opt:get_env(nsp_srv,http_address, "http://kakaranet.com")).
-define(HTTPS_ADDRESS, nsx_opt:get_env(nsp_srv,https_address, "https://kakaranet.com")).
-define(STATIC_ADDRESS, nsx_opt:get_env(nsp_srv,static_address, "http://static1.kakaranet.com")).
-define(FEED_PAGEAMOUNT, 20).

-define(FB_APP_ID, nsx_opt:get_env(nsp_srv, fb_id, "154227314626053")).
-define(FB_APP_SECRET, nsx_opt:get_env(nsp_srv, fb_secret, "cf9d49958ee536dd75f15bf8ca541965")).

