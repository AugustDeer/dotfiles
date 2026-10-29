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
        # TODO: Remove when nixpkgs updates hyprland to 0.57.0
        systemd.user.targets.hyprland-session.Unit = {
          Description = "Hyprland compositor session";
          Documentation = [ "man:systemd.special(7)" ];
          BindsTo = [ "graphical-session.target" ];
          Wants = [ "graphical-session-pre.target" ];
          After = [ "graphical-session-pre.target" ];
          PropagatesStopTo = [ "graphical-session.target" ];
        };

        xdg.configFile."hypr/hyprland.lua".source = "${inputs.config}/hypr/hyprland.lua";

        services.hyprpolkitagent.enable = true;
      }
    ];
  };
}
