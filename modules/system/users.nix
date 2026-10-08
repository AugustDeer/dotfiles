{
  flake.modules.nixos.users = { pkgs, ... }: {
    users.defaultUserShell = pkgs.zsh;
    programs.zsh.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
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
  };
}
