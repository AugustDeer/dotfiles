{ lib, ... }: {
  imports = [
    ./common.nix
    ./desktop
    ./home-manager.nix
  ];

  options.my.userName = lib.mkOption {
    default = "adeer";
    type = lib.types.str;
  };

  config.system.stateVersion = lib.mkDefault "26.05";
}
