{
  outputs =
    { self, ... }@args:
    let
      inputs = (import ./.tack) {
        overrides = args.tackOverrides or { };
      };

      inherit (inputs.nixpkgs) lib;

      src = "/home/adeer/dotfiles/"; # Must be current directory

      inputs' = inputs // {
        inherit self src pkgsFor;
        assets = ./assets;
        config = ./config;
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

      homeModules.default = import ./homeModules;

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            tack
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
