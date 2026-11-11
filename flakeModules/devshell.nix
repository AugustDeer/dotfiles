{
  perSystem =
    { config, pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          nh
          nix-update
          nix-diff
        ];

        inputsFrom = [ config.pre-commit.devShell ];
        inherit (config.pre-commit) shellHook;
      };
    };
}
