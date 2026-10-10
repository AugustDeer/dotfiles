{
  imports = [
    ./cli.nix
    ./desktop.nix
    ./theme.nix
  ];

  home.username = "adeer";
  home.homeDirectory = "/home/adeer";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
