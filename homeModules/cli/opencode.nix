{
  pkgs,
  src,
  config,
  ...
}:
{
  home.packages = [ pkgs.opencode ];

  xdg.configFile."opencode/agents".source =
    config.lib.file.mkOutOfStoreSymlink "${src}/config/opencode/agents";
}
