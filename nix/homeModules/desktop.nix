{ pkgs, ... }: {
  imports = [ ./mango.nix ];

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

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

  programs.kitty = {
    enable = true;
    settings = {
      enable_audio_bell = false;
      cursor_trail = 10;
      cursor_trail_decay = "0.05 0.2";
      custom_shaders = "cursor-trail-motion-blur";
    };
  };

  programs.firefox.enable = true;

  programs.vesktop.enable = true;
}
