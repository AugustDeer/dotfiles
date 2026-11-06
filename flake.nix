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
          # TEMPORARY fix for https://github.com/NixOS/nixpkgs/issues/582673
          # TODO: Remove once closed
          overlays = [
            (final: prev: {
              opencode = prev.opencode.overrideAttrs (
                old:
                final.lib.optionalAttrs
                  ((old.node_modules.outputHash or null) == "sha256-xfOVcw1+waLVNhFDwzOtzxrUSQEogvn88YomydOlhwc=")
                  {
                    node_modules = old.node_modules.overrideAttrs (_: {
                      outputHash = "sha256-prx9dX7kUvs/E3zopkaPk5LXh3xJAy5sZeum/W8L7cA=";
                    });
                  }
              );
            })
          ];
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

      nixosConfigurations = import ./hosts inputs;

      homeModules.default = import ./homeModules;

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            tack
            nh
            nix-update

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
