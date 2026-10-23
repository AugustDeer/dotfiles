{pkgs, lib, config, ...}: {
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

  xdg.configFile."nvim/init.lua" = {
    enable = lib.mkForce true;
    text = lib.mkForce null;
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/homeModules/neovim/init.lua";
  };
}
