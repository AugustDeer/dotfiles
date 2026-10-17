{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "usbhid"
        "sdhci_pci"
      ];
      kernelModules = [];
      luks.devices."luks-ef859b59-20ee-484f-a089-5cd8acfd06e8".device = "/dev/disk/by-uuid/ef859b59-20ee-484f-a089-5cd8acfd06e8";
    };
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/luks-ef859b59-20ee-484f-a089-5cd8acfd06e8";
      fsType = "btrfs";
    };

    "/nix" = {
      device = "/dev/mapper/luks-ef859b59-20ee-484f-a089-5cd8acfd06e8";
      fsType = "btrfs";
      options = ["subvol=nix"];
    };

    "/home" = {
      device = "/dev/mapper/luks-ef859b59-20ee-484f-a089-5cd8acfd06e8";
      fsType = "btrfs";
      options = ["subvol=home"];
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
    {device = "/dev/mapper/luks-f785ec98-a216-429b-85ae-94f440a19e62";}
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
