{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.my.desktop;
in {
  imports = [
    ./flatpak.nix
    ./gaming.nix
  ];

  options.my.desktop = {
    enable = lib.mkEnableOption "Enable desktop/gui-specific settings";
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
      hyprland = {
        enable = true;
        withUWSM = false;
      };

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
      hyprshutdown
    ];

    fonts.enableDefaultPackages = true;
    fonts.packages = with pkgs; [
      nerd-fonts.symbols-only
      nerd-fonts.fira-code
    ];
  };
}
