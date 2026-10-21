{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    extraConfig = builtins.readFile ./hyprland.lua;
  };
}
