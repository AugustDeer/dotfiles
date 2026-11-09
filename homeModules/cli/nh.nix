{ config, lib, ... }:
let
  cfg = config.my.shell;
in
{
  config = lib.mkIf cfg.enable {
    programs.nh = {
      enable = true;
      flake = "${config.home.homeDirectory}/dotfiles/";
    };
  };
}
