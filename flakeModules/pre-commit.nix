{ inputs, ... }: {
  imports = [ inputs.git-hooks.flakeModule ];

  perSystem = { pkgs, ... }: {
    pre-commit.settings = {
      hooks = {
        deadnix.enable = true;
        ruff = {
          enable = true;
          entry = "${pkgs.ruff}/bin/ruff check --no-fix";
        };
        statix.enable = true;
        treefmt.enable = true;
      };

      package = pkgs.prek;
    };
  };
}
