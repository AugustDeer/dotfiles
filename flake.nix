{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;

      src = "/home/adeer/dotfiles/"; # Must be current directory

      systems = [ "x86_64-linux" ];

      config = {
        allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "nvidia-x11"
            "nvidia-settings"

            "steam"
            "steam-unwrapped"
          ];
      };

      pkgsFor =
        system:
        import nixpkgs {
          inherit system config;
        };

      forAllSystems = f: lib.genAttrs systems (system: f (pkgsFor system));

      hostsDir = ./hosts;
      hosts = builtins.attrNames (
        lib.filterAttrs (_name: type: type == "directory") (builtins.readDir hostsDir)
      );
      mkHost =
        name:
        lib.nixosSystem {
          specialArgs = { inherit inputs src; };
          modules = [
            ./nixosModules
            (hostsDir + "/${name}")
            {
              networking.hostName = lib.mkDefault name;
              nixpkgs = { inherit config; };
            }
          ];
        };
    in
    {
      packages = forAllSystems (
        pkgs:
        lib.packagesFromDirectoryRecursive {
          inherit (pkgs) callPackage;
          directory = ./packages;
        }
      );

      formatter = forAllSystems (pkgs: pkgs.nixfmt-tree);

      nixosConfigurations = lib.genAttrs hosts mkHost;
    };
}
