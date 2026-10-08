{
  flake.modules.homeManager.desktop = { pkgs, ... }: {
    home.pointerCursor = {
      enable = true;
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ-AA";
      gtk.enable = true;
      x11.enable = true;
    };

    gtk = {
      enable = true;
      colorScheme = "dark";
      theme = {
        name = "Breeze";
        package = pkgs.kdePackages.breeze-gtk;
      };
      iconTheme = {
        name = "breeze-dark";
        package = pkgs.kdePackages.breeze-icons;
      };
    };

    programs.noctalia = {
      enable = true;

      settings.widget.clock = {
        format = "{:%-I:%M %p}";
      };
    };
  };
}
