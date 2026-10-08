{ withSystem, ... }:
{
  flake.modules.homeManager.cli =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.wl-clipboard
      ]
      ++ (withSystem pkgs.stdenv.hostPlatform.system (
        { config, inputs', ... }: [
          config.packages.neovim
          inputs'.nvf.packages.docs-manpages
        ]
      ));

      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };

      home.shellAliases.cat = "bat";

      programs.bash.enable = true;
      programs.zsh.enable = true;

      programs.starship = {
        enable = true;
        presets = [ "nerd-font-symbols" ];
      };

      programs.git = {
        enable = true;
        settings = {
          user = {
            name = "August Deer";
            email = "august@augustdeer.com";
          };
        };
      };
      programs.gh.enable = true;
      programs.delta = {
        enable = true;
        enableGitIntegration = true;
      };
      programs.lazygit.enable = true;

      programs.bat = {
        enable = true;
        config = {
          theme = "kanagawa";
        };
        extraPackages = with pkgs.bat-extras; [ batman ];
        themes = {
          kanagawa = {
            src = "${pkgs.vimPlugins.kanagawa-nvim}/extras/tmTheme/";
            file = "kanagawa.tmTheme";
          };
        };
      };

      programs.yazi.enable = true;

      programs.fzf.enable = true;

      programs.ripgrep.enable = true;

      programs.eza = {
        enable = true;
        icons = "auto";
      };

      programs.zoxide = {
        enable = true;
        options = [ "--cmd cd" ];
      };
    };
}
