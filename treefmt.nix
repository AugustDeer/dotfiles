{
  projectRootFile = "flake.nix";

  programs = {
    nixfmt.enable = true;
    statix.enable = true;
    deadnix.enable = true;
  };
}
