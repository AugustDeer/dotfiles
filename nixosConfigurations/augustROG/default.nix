{inputs, ...}: {
  imports = [
    ./hardware.nix
    ../../nixosModules/desktop.nix
    inputs.home-manager.nixosModules.default
  ];

  networking.hostName = "augustROG";

  boot.initrd.luks.devices."luks-f785ec98-a216-429b-85ae-94f440a19e62".device = "/dev/disk/by-uuid/f785ec98-a216-429b-85ae-94f440a19e62";

  system.stateVersion = "26.05";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    users.adeer = {
      imports = [../../homeModules];
    };
  };
}
