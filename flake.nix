{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }: {
        systems = [ "x86_64-linux" ];
        imports = [
          inputs.home-manager.flakeModules.home-manager
          inputs.git-hooks.flakeModule
          inputs.treefmt-nix.flakeModule

          ./hosts
          ./treefmt.nix
        ];

        perSystem =
          {
            config,
            pkgs,
            system,
            ...
          }:
          {
            _module.args.pkgs = import inputs.nixpkgs {
              inherit system;
              config.allowUnfreePredicate =
                pkg:
                builtins.elem (lib.getName pkg) [
                  "nvidia-x11"
                  "nvidia-settings"

                  "steam"
                  "steam-unwrapped"
                ];
            };

            devShells.default = pkgs.mkShell {
              packages = with pkgs; [
                nh
                nix-update

                nixd
                lua-language-server
              ];
              inputsFrom = [
                config.pre-commit.devShell
                config.treefmt.build.devShell
              ];
              inherit (config.pre-commit) shellHook;
            };

            packages = lib.packagesFromDirectoryRecursive {
              inherit (pkgs) callPackage;
              directory = ./packages;
            };
          };

        flake = {
          nixosModules.default = import ./nixosModules;
          homeModules.default = import ./homeModules;
        };
      }
    );
}
