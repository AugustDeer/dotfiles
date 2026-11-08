{ inputs, ... }: {
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem.treefmt.programs = {
    nixfmt.enable = true;
    statix.enable = true;
    deadnix.enable = true;

    stylua = {
      enable = true;

      settings = {
        indent_type = "Spaces";
        indent_width = 2;
      };
    };
  };
}
