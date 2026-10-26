{
  pkgs,
  src,
  config,
  ...
}:
{
  imports = [
    ./fastfetch.nix
    ./neovim.nix
  ];

  home = {
    packages = with pkgs; [
      opencode
    ];

    shellAliases.cat = "bat";
  };

  xdg.configFile."opencode/agents".source =
    config.lib.file.mkOutOfStoreSymlink "${src}/config/opencode/agents";

  programs = {
    bash.enable = true;
    zsh.enable = true;

    starship = {
      enable = true;
      presets = [ "nerd-font-symbols" ];
    };

    git = {
      enable = true;
      settings = {
        user = {
          name = "August Deer";
          email = "august@augustdeer.com";
        };
        commit.gpgSign = true;
        tag.gpgSign = true;
      };
    };
    gh.enable = true;
    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        side-by-side = true;
      };
    };
    lazygit.enable = true;

    direnv.enable = true;

    bat = {
      enable = true;
      config.theme = "kanagawa";
      themes.kanagawa = {
        src = "${pkgs.vimPlugins.kanagawa-nvim}/extras/tmTheme/";
        file = "kanagawa.tmTheme";
      };
    };

    yazi.enable = true;

    fzf.enable = true;

    ripgrep.enable = true;

    eza = {
      enable = true;
      icons = "auto";
    };

    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };

    nh = {
      enable = true;
      flake = src;
    };
  };
}
