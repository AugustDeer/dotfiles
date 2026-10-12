{
  imports = [
    ./cli.nix
    ./desktop.nix
    ./theme.nix
  ];

  home.username = "adeer";
  home.homeDirectory = "/home/adeer";
  home.stateVersion = "26.05";
}
