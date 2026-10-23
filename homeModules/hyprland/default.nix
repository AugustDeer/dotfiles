{config, ...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    extraLuaFiles = {
      "init".content = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/homeModules/hyprland/init.lua";
    };
  };

  services.hyprpolkitagent.enable = true;
}
