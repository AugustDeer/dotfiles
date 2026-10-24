{
  config,
  src,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    extraLuaFiles = {
      "init".content = config.lib.file.mkOutOfStoreSymlink "${src}/homeModules/hyprland/init.lua";
    };
  };

  services.hyprpolkitagent.enable = true;
}
