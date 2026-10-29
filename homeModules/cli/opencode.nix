{ pkgs, ... }: {
  home.packages = [ pkgs.opencode ];

  xdg.configFile."opencode/agents".source = ../../config/opencode/agents;
}
