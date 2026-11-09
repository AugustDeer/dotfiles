{
  lib,
  config,
  ...
}:
let
  cfg = config.my.desktop;
in
{
  options.my.desktop.flatpak = (lib.mkEnableOption "flatpak support") // {
    default = cfg.enable;
  };

  config = lib.mkIf cfg.flatpak {
    services.flatpak.enable = true;

    home-manager.sharedModules = [
      {
        xdg.systemDirs.data = [
          "/usr/share"
          "/var/lib/flatpak/exports/share"
          "$HOME/.local/share/flatpak/exports/share"
        ];
      }
    ];
  };
}
