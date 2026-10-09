{ outputs, ... }: {
  modules = [
    ./hardware.nix
    outputs.nixosModules.desktop
    {
      networking.hostName = "augustROG";

      boot.initrd.luks.devices."luks-f785ec98-a216-429b-85ae-94f440a19e62".device =
        "/dev/disk/by-uuid/f785ec98-a216-429b-85ae-94f440a19e62";

      system.stateVersion = "26.05";
    }
  ];
}
