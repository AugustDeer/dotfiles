{ inputs, ... }: {
  imports =
    with inputs.nixos-hardware.nixosModules;
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

  hardware.nvidia = {
    prime = {
      amdgpuBusId = "PCI:65@0:0:0";
      nvidiaBusId = "PCI:64@0:0:0";
    };

    dynamicBoost.enable = true;
  };

  services.asusd.enable = true;
  services.tuned.enable = true;
}
