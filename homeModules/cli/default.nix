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
  options.my.shell.enable = (lib.mkEnableOption "shell tools") // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ glow ];
    home.preferXdgDirectories = true;

    programs = {
      bash.enable = true;
      fish.enable = true;

      starship = {
        enable = true;
        presets = [ "nerd-font-symbols" ];
      };

      direnv = {
        enable = true;
        config = {
          global.hide_env_diff = true;
        };
      };

      yazi.enable = true;

      fzf.enable = true;

      fd.enable = true;

      ripgrep.enable = true;

      eza = {
        enable = true;
        icons = "auto";
      };

      zoxide = {
        enable = true;
        options = [ "--cmd cd" ];
      };

      uv.enable = true;
      npm.enable = true;
    };
  };
}
