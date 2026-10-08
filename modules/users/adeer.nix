{ inputs, config, ... }:
let
  homeManager = config.flake.modules.homeManager;
in
{
  flake.homeConfigurations.adeer = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
    modules = [ homeManager.adeer ];
  };

  flake.modules.homeManager.adeer = {
    imports = [
      homeManager.cli
      homeManager.terminal
      homeManager.desktop-apps
      homeManager.desktop
      homeManager.opencode
      homeManager.xdg
      homeManager.mango
    ];

    home.username = "adeer";
    home.homeDirectory = "/home/adeer";
    home.stateVersion = "26.05";

    programs.home-manager.enable = true;
  };
}
