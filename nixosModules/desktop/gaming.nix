{
  config,
  lib,
  pkgs,
  self',
  ...
}:
let
  cfg = config.my.desktop;
  myPkgs = self'.packages;
in
{
  options.my.desktop.gaming = lib.mkEnableOption "gaming packages and settings";

  config = lib.mkIf cfg.gaming {
    services.pipewire.alsa.support32Bit = true;
    programs.steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      protontricks.enable = true;
    };

    users.users.${config.my.userName}.packages = [
      pkgs.heroic
      pkgs.dolphin-emu
      pkgs.prismlauncher
      pkgs.smb1r

      myPkgs.eden-nightly
      myPkgs.eglantine
    ];
  };
}
