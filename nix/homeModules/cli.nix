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
    extraPackages = with pkgs.bat-extras; [ batman ];
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

  programs.nh = {
    enable = true;
    flake = "/home/adeer/dotfiles";
  };
}
