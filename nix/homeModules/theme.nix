let
  autumnGreen = "0x76946a";
  autumnRed = "0xc34043";
  crystalBlue = "0x7e9cd8";
  sumiInk1 = "0x1f1f28";
  sumiInk3 = "0x363646";
in
{ pkgs, ... }: {
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
    root_color = "${sumiInk1}ff";
    border_color = "${sumiInk3}ff";
    drop_color = "${autumnGreen}80";
    split_color = "${crystalBlue}ff";
    focus_color = "${autumnGreen}ff";
    urgent_color = "${autumnRed}ff";
  };
}
