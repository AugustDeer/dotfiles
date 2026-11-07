{
  outputs =
    flakeInputs:
    let
      src = "/home/adeer/dotfiles/"; # Must be current directory
      inputs = import ./.tack // flakeInputs // { inherit src; };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
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
              packages =
                (with pkgs; [
                  tack
                  nh
                  nix-update

                  nixd
                  lua-language-server
                ])
                ++ builtins.attrValues config.treefmt.build.programs;

              inherit (config.pre-commit) shellHook;
            };

            packages = pkgs.lib.packagesFromDirectoryRecursive {
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
