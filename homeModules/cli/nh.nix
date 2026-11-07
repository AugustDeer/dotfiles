{ inputs, ... }: {
  programs.nh.enable = true;
  programs.nh.flake = inputs.src;
}
