# Fixes for MediaTek MT7925 card
# Adapted from https://github.com/NixOS/nixos-hardware/blob/master/common/wifi/mediatek/mt7925/default.nix
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.hardware.mt7925 = lib.mkEnableOption "mt7925 fixes";

  config = lib.mkIf config.my.hardware.mt7925 {
    # Fix Wifi being incorrectly classified as "Ethernet"
    hardware.facter.detected.dhcp.enable = false;

    # Disable power management at driver level during module load
    boot.extraModprobeConfig = ''
      # MT7925 WiFi - disable all power management for stability
      options mt7925e disable_aspm=1
      options mt7925e power_save=0

      # Disable CLC (Country Location Code) - fixes 6GHz band stability
      options mt7925-common disable_clc=1
    '';

    networking.networkmanager.wifi = {
      # Disable WiFi power saving (causes disconnections)
      powersave = lib.mkDefault false;

      # Consistent MAC during scans (randomization causes issues)
      scanRandMacAddress = lib.mkDefault false;
    };

    systemd.services.mediatek-wifi-resume = {
      description = "Restart NetworkManager after suspend to fix MediaTek WiFi";
      wantedBy = [
        "suspend.target"
        "hibernate.target"
        "hybrid-sleep.target"
      ];
      after = [
        "suspend.target"
        "hibernate.target"
        "hybrid-sleep.target"
      ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/systemctl restart NetworkManager.service";
      };
    };
  };
}
