{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  noctalia = lib.getExe pkgs.noctalia;
in
{
  imports = [ inputs.mangowm.hmModules.mango ];

  wayland.windowManager.mango = {
    enable = true;
    settings = {
      monitor_rule = [
        "name:^eDP-1$,width:2560,height:1600,vrr:1,scale:1.25"
      ];

      cursor_size = config.home.pointerCursor.size;
      cursor_theme = config.home.pointerCursor.name;

      exec_once = noctalia;

      trackpad_natural_scrolling = 1;

      blur = 1;
      blur_params_num_passes = 2;

      border_radius = 10;

      dim_enable = 1;
      dim_unfocused_color = "0x00000022";

      animation_duration_focus = 100;

      circle_layout = "dwindle,scroller,monocle";

      dwindle_horizontal_split = 0;
      dwindle_vertical_split = 0;
      dwindle_preserve_split = 1;

      scroller_default_proportion = 0.5;
      scroller_proportion_preset = "1.0,0.8,0.5";

      bind = [
        "SUPER+SHIFT,R,reload_config"

        "SUPER,RETURN,spawn,kitty"
        "SUPER+SHIFT,Return,spawn,firefox"
        "SUPER+CTRL,Return,spawn,thunar"

        "SUPER,M,quit"
        "SUPER,Q,killclient,"

        "SUPER,TAB,focusstack,next"
        "SUPER,H,focusdir,left"
        "SUPER,L,focusdir,right"
        "SUPER,K,focusdir,up"
        "SUPER,J,focusdir,down"

        "SUPER+SHIFT,H,move_client,left"
        "SUPER+SHIFT,L,move_client,right"
        "SUPER+SHIFT,K,move_client,up"
        "SUPER+SHIFT,J,move_client,down"

        "SUPER+CTRL,H,scroller_stack,left"
        "SUPER+CTRL,L,scroller_stack,right"
        "SUPER+CTRL,K,scroller_stack,up"
        "SUPER+CTRL,J,scroller_stack,down"

        "SUPER,G,toggleglobal,"
        "ALT,TAB,togglejump,"
        "SUPER,V,togglefloating,"
        "SUPER,F,togglefullscreen,"
        "SUPER+SHIFT,F,togglefakefullscreen"
        "SUPER,I,minimized"
        "SUPER+SHIFT,I,restore_minimized"
        "SUPER,S,toggle_scratchpad"

        "SUPER,N,switch_layout"
        "SUPER,W,switch_proportion_preset"

        "SUPER,1,view,1,0"
        "SUPER,2,view,2,0"
        "SUPER,3,view,3,0"
        "SUPER,4,view,4,0"
        "SUPER,5,view,5,0"
        "SUPER,6,view,6,0"
        "SUPER,7,view,7,0"
        "SUPER,8,view,8,0"
        "SUPER,9,view,9,0"

        "SUPER+SHIFT,1,tag,1,0"
        "SUPER+SHIFT,2,tag,2,0"
        "SUPER+SHIFT,3,tag,3,0"
        "SUPER+SHIFT,4,tag,4,0"
        "SUPER+SHIFT,5,tag,5,0"
        "SUPER+SHIFT,6,tag,6,0"
        "SUPER+SHIFT,7,tag,7,0"
        "SUPER+SHIFT,8,tag,8,0"
        "SUPER+SHIFT,9,tag,9,0"

        "SUPER,SPACE,spawn,${noctalia} msg panel-toggle launcher"
        "SUPER,comma,spawn,${noctalia} msg settings-toggle"

        "NONE,XF86AudioRaiseVolume,spawn,${noctalia} msg volume-up"
        "NONE,XF86AudioLowerVolume,spawn,${noctalia} msg volume-down"
        "NONE,XF86AudioMute,spawn,${noctalia} msg volume-mute"
        "NONE,XF86MonBrightnessUp,spawn,${noctalia} msg brightness-up"
        "NONE,XF86MonBrightnessDown,spawn,${noctalia} msg brightness-down"

        "SUPER+SHIFT,S,spawn,${noctalia} msg screenshot-region"
      ];

      mousebind = [
        "SUPER,btn_left,moveresize,curmove"
        "SUPER,btn_right,moveresize,curresize"
      ];

      gesturebind = [
        "none,right,3,viewprev_have_client"
        "none,left,3,viewnext_have_client"
        "none,up,3,toggleoverview"
        "none,down,3,toggleoverview"
      ];
    };
  };
}
