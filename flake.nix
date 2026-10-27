{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;

      src = "/home/adeer/dotfiles/"; # Must be current directory

      inputs' = inputs // {
        inherit src pkgsFor;
      };

      systems = [ "x86_64-linux" ];

      myPkgs =
        pkgs:
        lib.packagesFromDirectoryRecursive {
          inherit (pkgs) callPackage;
          directory = ./packages;
        };

      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
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
        };

      forAllSystems = f: lib.genAttrs systems (system: f (pkgsFor system));
    in
    {
      packages = forAllSystems myPkgs;

      formatter = forAllSystems (pkgs: pkgs.nixfmt-tree);

      checks = forAllSystems (pkgs: {
        pre-commit-check = inputs.git-hooks.lib.${pkgs.stdenv.hostPlatform.system}.run {
          src = ./.;
          hooks = {
            nixfmt.enable = true;
            statix.enable = true;
            deadnix.enable = true;
          };
        };
      });

      nixosModules.default = import ./nixosModules;

      nixosConfigurations = import ./hosts inputs';

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            nh

            nixd
            nixfmt
            statix
            deadnix

            lua-language-server
          ];

          inherit (self.checks.${pkgs.stdenv.hostPlatform.system}.pre-commit-check) shellHook;
        };
      });
    };
}
