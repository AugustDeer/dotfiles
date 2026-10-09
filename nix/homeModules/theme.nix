{ pkgs, ... }:
let
  kanagawa = {
    sumiInk1 = "0x1f1f28";
    sumiInk3 = "0x363646";
    autumnGreen = "0x76946a";
    crystalBlue = "0x7e9cd8";
    autumnRed = "0xc34043";
  };
in
{
  programs.bat = {
    config.theme = "kanagawa";
    themes.kanagawa = {
      src = "${pkgs.vimPlugins.kanagawa-nvim}/extras/tmTheme/";
      file = "kanagawa.tmTheme";
    };
  };

  programs.kitty.themeFile = "kanagawa";

  programs.noctalia.settings.theme = {
    mode = "dark";
    source = "builtin";
    builtin = "Kanagawa";
  };

  wayland.windowManager.mango.settings = {
    root_color = "${kanagawa.sumiInk1}ff";
    border_color = "${kanagawa.sumiInk3}ff";
    drop_color = "${kanagawa.autumnGreen}80";
    split_color = "${kanagawa.crystalBlue}ff";
    focus_color = "${kanagawa.autumnGreen}ff";
    urgent_color = "${kanagawa.autumnRed}ff";
  };
}
