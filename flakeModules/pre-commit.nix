{ inputs, ... }: {
  imports = [ inputs.git-hooks.flakeModule ];

  perSystem.pre-commit.settings.hooks.treefmt.enable = true;
}
