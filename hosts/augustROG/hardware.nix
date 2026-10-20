{
  pkgs,
  inputs,
  ...
}: {
  imports = with inputs.nixos-hardware.nixosModules;
    [
      common-cpu-amd
      common-gpu-nvidia
      common-pc-laptop
      common-pc-laptop-ssd
    ]
    ++ map (path: import ("${inputs.nixos-hardware}/common/" + path)) [
      "gpu/nvidia/ada-lovelace"
      "wifi/mediatek/mt7925"
    ]
    ++ [
      ./hardware-configuration.nix
    ];

  hardware = {
    nvidia = {
      prime = {
        amdgpuBusId = "PCI:65@0:0:0";
        nvidiaBusId = "PCI:64@0:0:0";
      };

      dynamicBoost.enable = true;
    };

    display.edid.packages = [
      (pkgs.runCommand "edid-ATNA60DL04" {} ''
        mkdir -p "$out/lib/firmware/edid"
        cp ${./edid-patched-hdr.bin} "$out/lib/firmware/edid/ATNA60DL04-patched.bin"
      '')
    ];
    display.outputs."eDP-1".edid = "ATNA60DL04-patched.bin";
  };

  services.asusd.enable = true;
  services.tuned.enable = true;

  environment.sessionVariables = {
    WLR_DRM_NO_ATOMIC = 1;
  };

  boot.initrd.luks.devices."luks-f785ec98-a216-429b-85ae-94f440a19e62".device = "/dev/disk/by-uuid/f785ec98-a216-429b-85ae-94f440a19e62";
}
