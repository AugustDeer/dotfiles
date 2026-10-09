{ pkgs, ... }:
let
  autumnGreen = "76946a";
  sumiInk3 = "363646";
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

  programs.noctalia.settings = {
    theme = {
      mode = "dark";
      source = "builtin";
      builtin = "Kanagawa";
    };
    wallpaper.default.path = ../../assets/Great_Wave_off_Kanagawa2.jpg;
  };

  wayland.windowManager.hyprland.settings.config.general.col = {
    active_border = "#${autumnGreen}";
    inactive_border = "#${sumiInk3}";
  };
}
