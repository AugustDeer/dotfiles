{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    flake-parts,
    nixpkgs,
    nixos-hardware,
    home-manager,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} (top @ {
      config,
      withSystem,
      moduleWithSystem,
      ...
    }: {
      imports = [
        inputs.home-manager.flakeModules.home-manager
      ];

      flake = {
        nixosConfigurations.augustROG = inputs.nixpkgs.lib.nixosSystem {
          modules = [
            ./configuration.nix
            # Closest hardware to GA605W
            nixos-hardware.nixosModules.asus-zephyrus-gu605cw
            {
              hardware.nvidia.prime = nixpkgs.lib.mkForce {
                intelBusId = "";
                amdgpuBusId = "PCI:65@0:0:0";
                nvidiaBusId = "PCI:64@0:0:0";
              };
            }
          ];
        };

        homeConfigurations.adeer = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {system = "x86_64-linux";};
          modules = [./home.nix];
        };
      };

      systems = ["x86_64-linux"];

      perSystem = {inputs', ...}: {
        formatter = inputs'.nixpkgs.legacyPackages.alejandra;
      };
    });
}
