{
  perSystem = { config, ... }: {
    treefmt = {
      projectRootFile = "flake.nix";

      programs = {
        nixfmt.enable = true;
        statix.enable = true;
        deadnix.enable = true;
      };
    };

    pre-commit.settings.hooks.treefmt = {
      enable = true;
      packageOverrides.treefmt = config.treefmt.build.wrapper;
    };
  };
}
