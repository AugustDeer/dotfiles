{ lib, inputs, ... }: {
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem = { config, ... }: {
    pre-commit.settings.hooks.treefmt.settings.formatters =
      lib.attrValues config.treefmt.build.programs;

    treefmt.programs = {
      deno.enable = true;
      nixfmt.enable = true;
      stylua = {
        enable = true;
        settings = {
          indent_type = "Spaces";
          indent_width = 2;
        };
      };
    };
  };
}
