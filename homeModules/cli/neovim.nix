{ pkgs, inputs, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      blink-cmp
      gitsigns-nvim
      kanagawa-nvim
      lualine-nvim
      lz-n
      mini-nvim
      nvim-highlight-colors
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      which-key-nvim
    ];

    sideloadInitLua = true;
  };

  xdg.configFile."nvim".source = "${inputs.config}/nvim";
}
