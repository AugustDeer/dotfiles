{
  pkgs,
  inputs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  imports = [
    ./ghostty.nix
    ./noctalia.nix
    ./theming.nix
  ];

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
  };

  programs = {
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

    firefox.enable = true;

    keepassxc.enable = true;

    vesktop.enable = true;
  };

  services.syncthing = {
    enable = true;
  };
}
