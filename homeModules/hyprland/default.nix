{
  config,
  src,
  ...
}:
{
  systemd.user.targets.hyprland-session = {
    Unit = {
      Description = "Hyprland compositor session";
      Documentation = [ "man:systemd.special(7)" ];
      BindsTo = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
      After = [ "graphical-session-pre.target" ];
      PropagatesStopTo = [ "graphical-session.target" ];
    };
  };

  xdg.configFile."hypr".source = config.lib.file.mkOutOfStoreSymlink "${src}/config/hypr";

  services.hyprpolkitagent.enable = true;
}
