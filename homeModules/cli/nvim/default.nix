{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.shell;
in
{
  config = lib.mkIf cfg.enable {
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

      extraPackages = with pkgs; [
        lua-language-server
        nixd
        vscode-langservers-extracted
      ];
    };

    xdg.configFile."nvim".source = ./config;
  };
}
