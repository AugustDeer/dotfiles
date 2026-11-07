{
  perSystem = {
    treefmt.programs = {
      nixfmt.enable = true;
      statix.enable = true;
      deadnix.enable = true;
    };

    pre-commit.settings.hooks.treefmt.enable = true;
  };
}
