{ inputs, pkgs, ... }:
(inputs.nvf.lib.neovimConfiguration {
  inherit pkgs;
  modules = [
    {
      vim = {
        vimAlias = true;

        options = {
          shiftwidth = 2;
        };

        theme = {
          enable = true;
          name = "kanagawa";
          style = "wave";
        };

        autocomplete.blink-cmp.enable = true;

        autopairs.nvim-autopairs.enable = true;

        binds.whichKey.enable = true;

        clipboard = {
          enable = true;
          providers.wl-copy.enable = true;
        };

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

        telescope.enable = true;

        terminal.toggleterm = {
          enable = true;
          lazygit.enable = true;
        };
      };
    }
  ];
}).neovim
