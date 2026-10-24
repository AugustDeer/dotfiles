{
  pkgs,
  config,
  src,
  ...
}:
{
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
      which-key-nvim
    ];

    sideloadInitLua = true;
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${src}/config/nvim";
  };
}
