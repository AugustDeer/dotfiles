{ inputs, withSystem, ... }: {
  flake.homeModules.neovim = { pkgs, lib, ... }: {
    imports = [ inputs.nvf.homeManagerModules.nvf ];
    home.packages = [
      (withSystem pkgs.stdenv.hostPlatform.system ({ config, ... }: config.packages.neovim))
      inputs.nvf.packages.${pkgs.stdenv.hostPlatform.system}.docs-manpages
    ];
  };

  perSystem = { pkgs, ... }: {
    packages.neovim =
      (inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [
          {
            vim = {
              extraPlugins = with pkgs.vimPlugins; {
                kanagawa = {
                  package = kanagawa-nvim;
                  setup = /* lua */ "vim.cmd('colorscheme kanagawa')";
                };
              };

              vimAlias = true;

              options = {
                shiftwidth = 2;
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
      }).neovim;
  };
}
