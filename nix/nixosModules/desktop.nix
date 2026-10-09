{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ inputs.mangowm.nixosModules.mango ];

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
  services.greetd =
    let
      dbus-run-session = "${pkgs.dbus}/bin/dbus-run-session";
      cage = lib.getExe pkgs.cage;
      regreet = lib.getExe config.services.displayManager.regreet.package;
    in
    {
      settings.default_session.command = "env WLR_DRM_NO_ATOMIC=1 ${dbus-run-session} ${cage} -s -d -- ${regreet}";
    };

  programs.mango.enable = true;

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
}
