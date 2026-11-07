{ inputs, ... }: {
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake = {
    nixosModules.default = inputs.import-tree ../nixosModules;

    homeModules.default = inputs.import-tree ../homeModules;
  };
}
