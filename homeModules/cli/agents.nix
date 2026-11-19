{
  config,
  lib,
  pkgs,
  self',
  ...
}:
let
  cfg = config.my.shell;
in
{
  options.my.shell.agents = (lib.mkEnableOption "coding agents") // {
    default = true;
  };

  config = lib.mkIf (cfg.enable && cfg.agents) {
    home.packages = [
      self'.packages.omp
      pkgs.opencode
      pkgs.pi-coding-agent
      self'.packages.tern
    ];
  };
}
