{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    extraConfig = builtins.readFile ./hyprland.lua;
  };
}
