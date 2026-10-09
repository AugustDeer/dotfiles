{ config, ... }: {
  system = "x86_64-linux";
  modules = with config.homeModules; [
    cli
    terminal
    desktop-apps
    desktop
    opencode
    xdg
    mango
    theme
    {
      home.username = "adeer";
      home.homeDirectory = "/home/adeer";
      home.stateVersion = "26.05";

      programs.home-manager.enable = true;
    }
  ];
}
