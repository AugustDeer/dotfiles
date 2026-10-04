{
  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = inputs @ {
    self,
    flake-parts,
    nixpkgs,
    nixos-hardware,
    home-manager,
    mangowm,
    nixvim,
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
            mangowm.nixosModules.mango
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
          modules = [
            mangowm.hmModules.mango
            nixvim.homeModules.nixvim
            ./home.nix
          ];
        };
      };

      systems = ["x86_64-linux"];

      perSystem = {inputs', ...}: {
        formatter = inputs'.nixpkgs.legacyPackages.alejandra;
      };
    });
}
