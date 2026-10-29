{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  cfg = config.my.desktop;
in
{
  imports = [
    ./flatpak.nix
    ./gaming.nix
    ./hyprland.nix
  ];

  options.my.desktop = {
    enable = lib.mkEnableOption "desktop/gui-specific settings";
    environment = lib.mkOption {
      default = "hyprland";
      description = "Which desktop environment to use.";
      type = lib.types.enum [ "hyprland" ];
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      # Enable sound with pipewire.
      pulseaudio.enable = false;
      pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };

      # Enable CUPS to print documents.
      printing.enable = true;

      # Configure keymap in X11.
      xserver.xkb = {
        layout = "us";
        variant = "";
      };

      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;

      displayManager.noctalia-greeter.enable = true;

      gvfs.enable = true;
      tumbler.enable = true;

      gnome.gnome-keyring.enable = true;
    };

    security.rtkit.enable = true;

    hardware.graphics.enable = true;

    programs = {
      thunar = {
        enable = true;
        plugins = with pkgs; [
          thunar-volman
          thunar-archive-plugin
        ];
      };
      dconf.enable = true;
    };

    environment.systemPackages = with pkgs; [
      brightnessctl
      file-roller
    ];

    fonts = {
      enableDefaultPackages = true;

      fontconfig = {
        defaultFonts = {
          serif = [ "Liberation Serif" ];
          sansSerif = [ "Liberation Sans" ];
          monospace = [ "FiraCode Nerd Font" ];
        };
        subpixel.rgba = "rgb";
      };

      packages = with pkgs; [
        nerd-fonts.symbols-only
        nerd-fonts.fira-code
        inputs.self.packages.${system}.pixeloperator
      ];
    };
  };
}
