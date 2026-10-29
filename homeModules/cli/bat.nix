{ pkgs, ... }: {
  programs.bat = {
    enable = true;
    config.theme = "kanagawa";
    themes.kanagawa = {
      src = "${pkgs.vimPlugins.kanagawa-nvim}/extras/tmTheme/";
      file = "kanagawa.tmTheme";
    };
  };

  home.shellAliases.cat = "bat";
}
