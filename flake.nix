{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    llm-agents,
    ...
  }: let
    inherit (nixpkgs) lib;

    pkgsDir = ./packages;
    myPackages = pkgs:
      lib.packagesFromDirectoryRecursive {
        inherit (pkgs) callPackage;
        directory = pkgsDir;
      };

    systems = ["x86_64-linux"];

    config = {
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "nvidia-x11"
          "nvidia-settings"

          "steam"
          "steam-unwrapped"
        ];
    };

    overlays = [
      (final: _prev: myPackages final)
      llm-agents.overlays.shared-nixpkgs
    ];

    pkgsFor = system:
      import nixpkgs {
        inherit system config overlays;
      };

    forAllSystems = f: lib.genAttrs systems (system: f (pkgsFor system));

    hostsDir = ./hosts;
    hosts = builtins.attrNames (lib.filterAttrs (_name: type: type == "directory") (builtins.readDir hostsDir));
    mkHost = name:
      lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./nixosModules
          (hostsDir + "/${name}")
          {
            networking.hostName = name;
            nixpkgs = {inherit config overlays;};
          }
        ];
      };
  in {
    packages = forAllSystems myPackages;

    formatter = forAllSystems (pkgs: pkgs.alejandra);

    nixosConfigurations = lib.genAttrs hosts mkHost;
  };
}
