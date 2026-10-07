{ inputs, withSystem, ... }: {
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake.homeModules.neovim = { pkgs, lib, ... }: {
    imports = [ inputs.nvf.homeManagerModules.nvf ];
    home.packages = [
      (withSystem pkgs.stdenv.hostPlatform.system ({ config, ... }: config.packages.neovim))
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

              mini.basics.enable = true;

              binds.whichKey.enable = true;

              clipboard.enable = true;

              lsp.enable = true;

              autocomplete.blink-cmp.enable = true;

              languages = {
                enableTreesitter = true;
                enableFormat = true;
                enableExtraDiagnostics = true;

                nix.enable = true;
              };
            };

          }
        ];
      }).neovim;
  };
}
