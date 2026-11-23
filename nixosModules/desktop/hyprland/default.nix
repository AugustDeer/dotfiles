{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.desktop;
in
{
  config = lib.mkIf (cfg.enable && cfg.environment == "hyprland") {
    programs.hyprland.enable = true;

    environment.systemPackages = [ pkgs.hyprshutdown ];

    home-manager.sharedModules = [
      {
        xdg.configFile."hypr/hyprland.lua".source = ./hyprland.lua;
        xdg.configFile."hypr/hdr-brightness.sh".source = ./hdr-brightness.sh;

        services.hyprpolkitagent.enable = true;
      }
    ];
  };
}
