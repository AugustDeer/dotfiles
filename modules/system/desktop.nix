{
  flake.modules.nixos.desktop = { pkgs, ... }: {
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

    services.displayManager.ly.enable = true;

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
  };
}
