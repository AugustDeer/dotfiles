{
  imports = [
    ./cli.nix
    ./desktop.nix
    ./theme.nix
  ];

  home = {
    username = "adeer";
    homeDirectory = "/home/adeer";
    stateVersion = "26.05";
  };
}
