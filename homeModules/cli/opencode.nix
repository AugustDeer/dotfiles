{ pkgs, inputs, ... }: {
  home.packages = [ pkgs.opencode ];

  xdg.configFile."opencode/agents".source = "${inputs.config}/opencode/agents";
}
