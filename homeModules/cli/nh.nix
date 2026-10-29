{ src, ... }: {
  programs.nh.enable = true;
  programs.nh.flake = src;
}
