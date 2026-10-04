{
  inputs = {
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
  outputs = inputs@{ self, nixpkgs, nixos-hardware, home-manager, ... }: {
    nixosConfigurations.augustROG = nixpkgs.lib.nixosSystem {
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
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = { inherit inputs; };
      modules = [ ./home.nix ];
    };
  };
}

