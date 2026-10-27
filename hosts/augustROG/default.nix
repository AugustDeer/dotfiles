{
  imports = [ ./hardware.nix ];

  networking.hostName = "augustROG";

  my.desktop = {
    enable = true;
    gaming = true;
  };
}
