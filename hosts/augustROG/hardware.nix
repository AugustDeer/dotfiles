{ pkgs, ... }: {
  hardware.facter = {
    reportPath = ./facter.json;
    detected.dhcp.enable = false; # Fix WiFi being incorrectly classified as "Ethernet"
    detected.boot.graphics.kernelModules = [ ]; # Remove unnecessary GPU drivers from initrd
  };

  boot = {
    initrd.luks.devices = {
      "luks-ef859b59-20ee-484f-a089-5cd8acfd06e8".device =
        "/dev/disk/by-uuid/ef859b59-20ee-484f-a089-5cd8acfd06e8";
      "luks-f785ec98-a216-429b-85ae-94f440a19e62".device =
        "/dev/disk/by-uuid/f785ec98-a216-429b-85ae-94f440a19e62";
    };

    extraModprobeConfig = ''
      # MT7925 WiFi - disable all power management for stability
      options mt7925e disable_aspm=1
      options mt7925e power_save=0

      # Disable CLC (Country Location Code) - fixes 6GHz band stability
      options mt7925-common disable_clc=1
    '';
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/luks-ef859b59-20ee-484f-a089-5cd8acfd06e8";
      fsType = "btrfs";
    };

    "/nix" = {
      device = "/dev/mapper/luks-ef859b59-20ee-484f-a089-5cd8acfd06e8";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

    "/home" = {
      device = "/dev/mapper/luks-ef859b59-20ee-484f-a089-5cd8acfd06e8";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/7541-4241";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };

  swapDevices = [
    { device = "/dev/mapper/luks-f785ec98-a216-429b-85ae-94f440a19e62"; }
  ];

  hardware = {
    nvidia = {
      open = true;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        amdgpuBusId = "PCI:65@0:0:0";
        nvidiaBusId = "PCI:64@0:0:0";
      };
    };

    display.edid.packages = [
      (pkgs.runCommand "edid-ATNA60DL04" { } ''
        mkdir -p "$out/lib/firmware/edid"
        cp ${./edid-patched-hdr.bin} "$out/lib/firmware/edid/ATNA60DL04-patched.bin"
      '')
    ];
    display.outputs."eDP-1".edid = "ATNA60DL04-patched.bin";
  };

  services = {
    asusd.enable = true;
    tuned.enable = true;
    xserver.videoDrivers = [ "nvidia" ];
  };

  networking.networkmanager.wifi = {
    powersave = false;
    scanRandMacAddress = false;
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

  environment.sessionVariables = {
    WLR_DRM_NO_ATOMIC = 1; # Greetd greeter uses wlroots-based cage compositor
  };
}
