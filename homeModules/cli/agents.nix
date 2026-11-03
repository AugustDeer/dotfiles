{ pkgs, ... }: {
  home.packages = [
    pkgs.opencode
    pkgs.pi-coding-agent
  ];
}
