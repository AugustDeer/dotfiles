{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.my.desktop;
in {
  imports = [./flatpak.nix];

  options.my.desktop = {
    enable = lib.mkEnableOption "Enable desktop/gui-specific settings";
  };

  config = lib.mkIf cfg.enable {
    my.desktop.flatpak = lib.mkDefault true;

    services = {
      # Enable sound with pipewire.
      pulseaudio.enable = false;
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
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

      displayManager.regreet = {
        enable = true;
        settings = {
          background.path = ../../assets/AugustWallpaperBackground.png;
          GTK.application_prefer_dark_theme = true;
          widget.clock.format = "%a %-I:%M %p";
        };
      };
      gvfs.enable = true;
      tumbler.enable = true;

      gnome.gnome-keyring.enable = true;
    };

    security.rtkit.enable = true;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    programs = {
      mango.enable = true;

      thunar = {
        enable = true;
        plugins = with pkgs; [
          thunar-volman
          thunar-archive-plugin
        ];
      };
      dconf.enable = true;

      steam.enable = true;
    };

    environment.systemPackages = with pkgs; [
      brightnessctl
      file-roller
    ];

    fonts.enableDefaultPackages = true;
    fonts.packages = with pkgs; [
      nerd-fonts.symbols-only
      nerd-fonts.fira-code
    ];
  };
}
