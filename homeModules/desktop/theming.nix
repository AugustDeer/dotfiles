{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.desktop;
  theme = {
    name = "Yaru-blue-dark";
    package = pkgs.yaru-theme;
  };
in
{
  config = lib.mkIf cfg.enable {
    home.pointerCursor = theme // {
      enable = true;
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };

    gtk = {
      enable = true;
      colorScheme = "dark";
      inherit theme;
      iconTheme = theme;
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk3";
    };
  };
}
