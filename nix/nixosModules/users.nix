{ pkgs, ... }: {
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  users.users."adeer" = {
    isNormalUser = true;
    description = "August Deer";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "render"
    ];
  };
}
