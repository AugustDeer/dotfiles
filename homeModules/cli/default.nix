{ pkgs, ... }: {
  imports = [
    ./agents.nix
    ./bat.nix
    ./fastfetch.nix
    ./git.nix
    ./neovim.nix
    ./nh.nix
  ];

  home.packages = with pkgs; [ glow ];

  programs = {
    bash.enable = true;
    zsh.enable = true;

    starship = {
      enable = true;
      presets = [ "nerd-font-symbols" ];
    };

    direnv.enable = true;

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

    uv.enable = true;
  };
}
