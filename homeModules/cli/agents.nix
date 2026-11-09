{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.shell;
in
{
  options.my.shell.agents = (lib.mkEnableOption "coding agents") // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf cfg.agents [
      pkgs.opencode
      pkgs.pi-coding-agent
    ];
  };
}
