{
  perSystem =
    { config, pkgs, ... }:
    {
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
    };
}
