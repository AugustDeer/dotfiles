{
  programs.nix-ld.enable = true;

  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];
}
