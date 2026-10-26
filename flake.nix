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

      systems = [ "x86_64-linux" ];

      myPkgs =
        pkgs:
        lib.packagesFromDirectoryRecursive {
          inherit (pkgs) callPackage;
          directory = ./packages;
        };

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
      overlay = final: _prev: { my = myPkgs final; };
      overlays = [ overlay ];

      pkgsFor =
        system:
        import nixpkgs {
          inherit system config overlays;
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

      nixosConfigurations = lib.genAttrs hosts mkHost;

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
