{
  my.hardware.mt7925 = true;

  hardware = {
    facter = {
      reportPath = ./facter.json;
      detected.boot.graphics.kernelModules = [ ]; # Remove unnecessary GPU drivers from initrd
    };

    nvidia = {
      open = true;
      branch = "latest";
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        amdgpuBusId = "PCI:65@0:0:0";
        nvidiaBusId = "PCI:64@0:0:0";
      };
    };
  };

  services = {
    asusd.enable = true;
    tuned.enable = true;
    xserver.videoDrivers = [ "nvidia" ];
  };

  environment.sessionVariables = {
    WLR_DRM_NO_ATOMIC = 1; # Greetd greeter uses wlroots-based cage compositor
  };
}
