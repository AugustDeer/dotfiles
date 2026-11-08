{ inputs, ... }: {
  imports = [ inputs.git-hooks.flakeModule ];

  perSystem = { pkgs, ... }: {
    pre-commit.settings = {
      hooks = {
        deadnix.enable = true;
        statix.enable = true;
        treefmt.enable = true;
      };

      package = pkgs.prek;
    };
  };
}
