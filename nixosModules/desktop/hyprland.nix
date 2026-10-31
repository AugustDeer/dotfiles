{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  config = lib.mkIf (config.my.desktop.environment == "hyprland") {
    programs.hyprland.enable = true;

    environment.systemPackages = [ pkgs.hyprshutdown ];

    home-manager.sharedModules = [
      {
        xdg.configFile."hypr/hyprland.lua".source = "${inputs.config}/hypr/hyprland.lua";

        services.hyprpolkitagent.enable = true;
      }
    ];
  };
}
