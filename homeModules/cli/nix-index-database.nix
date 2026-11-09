{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.my.shell;
in
{
  imports = [ inputs.nix-index-database.homeModules.default ];

  options.my.shell.comma = (lib.mkEnableOption "comma") // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    programs.nix-index-database.comma.enable = cfg.comma;
  };
}
