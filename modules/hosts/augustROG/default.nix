{ config, lib, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  flake.nixosConfigurations.augustROG = lib.nixosSystem {
    modules = [ nixos.augustROG ];
  };

  flake.modules.nixos.augustROG = {
    imports = [
      nixos.augustROG-hardware
      nixos.boot
      nixos.nix
      nixos.packages
      nixos.network
      nixos.locale
      nixos.audio
      nixos.desktop
      nixos.gaming
      nixos.users
      # Include the results of the hardware scan.
      ./_hardware-configuration.nix
    ];

    networking.hostName = "augustROG";

    boot.initrd.luks.devices."luks-f785ec98-a216-429b-85ae-94f440a19e62".device =
      "/dev/disk/by-uuid/f785ec98-a216-429b-85ae-94f440a19e62";

    system.stateVersion = "26.05";
  };
}
