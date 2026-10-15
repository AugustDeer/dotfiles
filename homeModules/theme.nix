{ pkgs, ... }: {
  programs = {
    bat = {
      config.theme = "kanagawa";
      themes.kanagawa = {
        src = "${pkgs.vimPlugins.kanagawa-nvim}/extras/tmTheme/";
        file = "kanagawa.tmTheme";
      };
    };

    nvf.settings.vim.theme = {
      enable = true;
      name = "kanagawa";
      style = "wave";
      transparent = true;
    };

    kitty.themeFile = "kanagawa";

    noctalia.settings.theme = {
      mode = "dark";
      source = "builtin";
      builtin = "Kanagawa";
    };

    opencode.tui.theme = "kanagawa";
  };
}
