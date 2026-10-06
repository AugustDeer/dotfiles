{ inputs, ... }: {
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake.homeModules.neovim = { pkgs, ... }: {
    imports = [ inputs.nvf.homeManagerModules.nvf ];
    programs.nvf = {
      enable = true;
      defaultEditor = true;
      settings.vim = {
        extraPlugins = with pkgs.vimPlugins; {
          kanagawa = {
            package = kanagawa-nvim;
            setup = /* lua */ "vim.cmd('colorscheme kanagawa')";
          };
        };

        vimAlias = true;

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
    };
  };
}
