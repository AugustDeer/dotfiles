{
  outputs =
    { self, ... }:
    let
      inputs = import ./.tack // {
        inherit self src pkgsFor;
        assets = ./assets;
        config = ./config;
      };

      inherit (inputs.nixpkgs) lib;

      src = "/home/adeer/dotfiles/"; # Must be current directory

      systems = [ "x86_64-linux" ];

      myPkgs = pkgs: import ./. { inherit pkgs; };

      pkgsFor = lib.genAttrs systems (
        system:
        import inputs.nixpkgs {
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
        }
      );

      forAllSystems = f: lib.mapAttrs (_: f) pkgsFor;

      treefmtFor = pkgs: (inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix).config.build.wrapper;
    in
    {
      packages = forAllSystems myPkgs;

      formatter = forAllSystems treefmtFor;

      checks = forAllSystems (pkgs: {
        pre-commit-check = inputs.git-hooks.lib.${pkgs.stdenv.hostPlatform.system}.run {
          src = ./.;
          hooks.treefmt = {
            enable = true;
            packageOverrides.treefmt = treefmtFor pkgs;
          };
        };
      });

      nixosModules.default = import ./nixosModules;

      nixosConfigurations = import ./hosts inputs;

      homeModules.default = import ./homeModules;

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            tack
            nh
            nix-update

            nixd
            lua-language-server

            self.formatter.${pkgs.stdenv.hostPlatform.system}
          ];

          inherit (self.checks.${pkgs.stdenv.hostPlatform.system}.pre-commit-check) shellHook;
        };
      });
    };
}
