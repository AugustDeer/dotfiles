{ pkgs, ... }:
let
  autumnGreen = "76946a";
  autumnRed = "c34043";
  crystalBlue = "7e9cd8";
  sumiInk1 = "1f1f28";
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

  wayland.windowManager.mango.settings = {
    root_color = "0x${sumiInk1}ff";
    border_color = "0x${sumiInk3}ff";
    drop_color = "0x${autumnGreen}80";
    split_color = "0x${crystalBlue}ff";
    focus_color = "0x${autumnGreen}ff";
    urgent_color = "0x${autumnRed}ff";
  };

  wayland.windowManager.hyprland.settings.config.general.col = {
    active_border = "#${autumnGreen}";
    inactive_border = "#${sumiInk3}";
  };
}
