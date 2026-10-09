{ flake, pkgs, ... }: {
  home.packages = [
    pkgs.wl-clipboard
    flake.outputs'.packages.neovim
    flake.inputs'.nvf.packages.docs-manpages
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.shellAliases.cat = "bat";

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
      };
    };
    gh.enable = true;
    delta = {
      enable = true;
      enableGitIntegration = true;
    };
    lazygit.enable = true;

    bat.enable = true;

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

    opencode = {
      enable = true;
      tui.theme = "kanagawa";
    };

    nh = {
      enable = true;
      flake = "/home/adeer/dotfiles";
    };
  };
}
