{
  perSystem =
    { config, pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          nh
          nix-diff

          nixd
          lua-language-server
        ];

        inputsFrom = [ config.pre-commit.devShell ];
        inherit (config.pre-commit) shellHook;
      };
    };
}
