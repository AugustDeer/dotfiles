{
  flake.modules.nixos.network = {
    networking.networkmanager.enable = true;

    hardware.bluetooth.enable = true;
  };
}
