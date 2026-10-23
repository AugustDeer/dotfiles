{pkgs, ...}: {
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
      nvim-lspconfig
      telescope-nvim
      which-key-nvim
    ];

    initLua = builtins.readFile ./init.lua;
  };
}
