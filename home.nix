{ config, pkgs, ... }:

{
  home.username = "adeer";
  home.homeDirectory = "/home/adeer";

  home.stateVersion = "26.05";


  programs.home-manager.enable = true;

  programs.bash.enable = true;

  programs.starship.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "August Deer";
        email = "august@augustdeer.com";
      };
    };
  };

  programs.firefox.enable = true;

  programs.kitty.enable = true;

  programs.noctalia.enable = true;


  gtk = {
    enable = true;
    colorScheme = "dark";
  };
}
