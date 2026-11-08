{ pkgs, ... }: {
  home.packages = with pkgs; [ glow ];

  programs = {
    bash.enable = true;
    zsh = {
      enable = true;
      defaultKeymap = "emacs";
    };

    starship = {
      enable = true;
      presets = [ "nerd-font-symbols" ];
    };

    direnv.enable = true;

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
}
