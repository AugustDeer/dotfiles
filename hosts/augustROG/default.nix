{inputs, ...}: {
  imports = [
    ./hardware.nix
    ../../nixosModules/desktop.nix
    inputs.home-manager.nixosModules.default
  ];

  networking.hostName = "augustROG";

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
