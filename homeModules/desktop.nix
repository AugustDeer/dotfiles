{
  pkgs,
  inputs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  imports = [ ./hyprland.nix ];

  home.packages = with pkgs; [
    wl-clipboard
    inkscape
    heroic

    proton-vpn

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
        file-roller
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

  programs = {
    noctalia = {
      enable = true;

      # Dependencies for Wallpaper Depth plugin
      package =
        let
          wrapped-python = pkgs.python314.withPackages (
            ps: with ps; [
              numpy
              onnxruntime
              pillow
            ]
          );
        in
        pkgs.symlinkJoin {
          inherit (pkgs.noctalia) version meta;
          pname = "noctalia-wrapped";
          buildInputs = [ pkgs.makeBinaryWrapper ];
          paths = [ pkgs.noctalia ];
          postBuild = ''
            wrapProgram $out/bin/noctalia \
              --prefix PATH : ${pkgs.lib.makeBinPath [ wrapped-python ]}
          '';
        };

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
    ghostty =
      let
        cursor_warp = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/sahaj-b/cursor-shaders/9ad9158a93c0de0c045e1c6b27df37da698bc8af/ghostty/cursor_warp.glsl";
          hash = "sha256-WJ9x9TfO6JCgfkCPE9Bi/32T3m2fdCyE5L3mEExdUfs=";
        };
      in
      {
        enable = true;
        settings = {
          background-opacity = 0.8;
          custom-shader = "${cursor_warp}";
          font-family = "FiraCode Nerd Font";
          scrollbar = "never";
          theme = "Kanagawa Wave";
        };
      };

    firefox.enable = true;

    keepassxc.enable = true;

    vesktop.enable = true;
  };

  services.syncthing = {
    enable = true;
  };
}
