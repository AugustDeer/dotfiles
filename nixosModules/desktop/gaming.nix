{
  lib,
  config,
  ...
}: let
  cfg = config.my.desktop;
in {
  options.my.desktop.gaming = lib.mkEnableOption "gaming packages and settings";

  config = lib.mkIf cfg.gaming {
    services.pipewire.alsa.support32Bit = true;
    hardware.graphics.enable32Bit = true;
    programs.steam.enable = true;
  };
}
