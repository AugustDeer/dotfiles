{
  pkgs,
  inputs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;
in {
  imports = [./hyprland];

  home.packages = with pkgs; [
    wl-clipboard
    inkscape
    heroic
    dolphin-emu
    prismlauncher
    inputs.self.packages.${system}.smb1r
  ];

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
    mimeApps = {
      enable = true;
      defaultApplicationPackages = with pkgs; [
        xarchiver
        firefox
        vesktop
      ];
    };
    configFile."xfce4/helpers.rc".text = ''
      TerminalEmulator=ghostty
    '';
  };

  home.pointerCursor = {
    enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
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
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  programs = {
    noctalia = {
      enable = true;

      settings = {
        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Kanagawa";
        };
        widget.clock = {
          format = "{:%-I:%M %p}";
        };
      };
    };

    kitty = {
      enable = true;
      themeFile = "kanagawa";
      settings = {
        font_family = "FiraCode Nerd Font";
        background_opacity = 0.85;
        enable_audio_bell = false;
        cursor_trail = 10;
        cursor_trail_decay = "0.05 0.2";
        custom_shaders = "cursor-trail-motion-blur";
      };
    };
    ghostty = let
      cursor_warp = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/sahaj-b/cursor-shaders/9ad9158a93c0de0c045e1c6b27df37da698bc8af/ghostty/cursor_warp.glsl";
        hash = "sha256-WJ9x9TfO6JCgfkCPE9Bi/32T3m2fdCyE5L3mEExdUfs=";
      };
    in {
      enable = true;
      settings = {
        theme = "Kanagawa Wave";
        font-family = "FiraCode Nerd Font Mono";
        background-opacity = 0.9;
        custom-shader = "${cursor_warp}";
      };
    };

    firefox.enable = true;

    vesktop.enable = true;
  };
}
