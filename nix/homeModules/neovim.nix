{ inputs, ... }: {
  imports = [ inputs.nvf.homeManagerModules.default ];

  programs.nvf = {
    enable = true;
    enableManpages = true;
    settings.vim = {
      vimAlias = true;

      options = {
        shiftwidth = 2;
      };

      theme = {
        enable = true;
        name = "kanagawa";
        style = "wave";
      };

      keymaps =
        let
          wincmd = k: {
            key = "<C-${k}>";
            mode = "n";
            action = ":wincmd ${k}<CR>";
          };
        in
        [
          {
            key = "<leader>n";
            mode = "n";
            action = ":Neotree toggle<CR>";
          }
          (wincmd "h")
          (wincmd "j")
          (wincmd "k")
          (wincmd "l")
        ];

      autocomplete.blink-cmp.enable = true;

      autopairs.nvim-autopairs.enable = true;

      binds.whichKey.enable = true;

      clipboard = {
        enable = true;
        providers.wl-copy.enable = true;
      };

      filetree.neo-tree.enable = true;

      git.enable = true;

      languages = {
        enableTreesitter = true;
        enableFormat = true;
        enableExtraDiagnostics = true;

        nix = {
          enable = true;
          format.type = [ "nixfmt" ];
        };
        markdown = {
          enable = true;
          extensions.markview-nvim.enable = true;
        };
      };

      lsp.enable = true;

      mini.basics.enable = true;

      statusline.lualine.enable = true;

      tabline.nvimBufferline.enable = true;

      telescope.enable = true;

      terminal.toggleterm = {
        enable = true;
        lazygit.enable = true;
      };
    };
  };
}
