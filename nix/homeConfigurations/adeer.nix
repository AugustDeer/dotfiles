{ config, ... }: {
  system = "x86_64-linux";
  modules = with config.homeModules; [
    cli
    desktop
    theme
    {
      home.username = "adeer";
      home.homeDirectory = "/home/adeer";
      home.stateVersion = "26.05";

      programs.home-manager.enable = true;
    }
  ];
}
