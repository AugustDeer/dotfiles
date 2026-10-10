{ inputs, pkgs, ... }: {
  imports = [
    ./common.nix
    inputs.mangowm.nixosModules.mango
  ];

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Configure keymap in X11.
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  services.displayManager.regreet = {
    enable = true;
    settings = {
      GTK.application_prefer_dark_theme = true;
      widget.clock.format = "%a %-I:%M %p";
    };
  };

  programs.mango.enable = true;
  programs.hyprland.enable = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-volman
    ];
  };
  programs.dconf.enable = true;
  services.gvfs.enable = true;

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
  ];

  programs.steam.enable = true;
}
