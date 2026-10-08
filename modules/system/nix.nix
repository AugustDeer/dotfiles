{
  flake.modules.nixos.nix = {
    programs.nix-ld.enable = true;

    # Allow unfree packages.
    nixpkgs.config.allowUnfree = true;

    nix.settings.experimental-features = [
      "flakes"
      "nix-command"
    ];
  };
}
