{ pkgs, ... }: {
  home.pointerCursor = {
    enable = true;
    package = pkgs.yaru-theme;
    name = "Yaru-blue-dark";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  gtk = {
    enable = true;
    colorScheme = "dark";
    theme = {
      name = "Yaru-blue-dark";
      package = pkgs.yaru-theme;
    };
    iconTheme = {
      name = "Yaru-blue-dark";
      package = pkgs.yaru-theme;
    };
  };
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };
}
