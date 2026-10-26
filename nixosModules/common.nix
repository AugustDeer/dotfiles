{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.my.common;
in
{
  options.my.common.enable = lib.mkOption {
    default = true;
    description = "Enable general system configuration";
    type = lib.types.bool;
  };

  config = lib.mkIf cfg.enable {
    boot = {
      # Use the systemd-boot EFI boot loader.
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;

      # Use latest kernel.
      kernelPackages = pkgs.linuxPackages_latest;
    };

    # Set your time zone.
    time.timeZone = "America/Chicago";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    networking.networkmanager.enable = true;

    services.tailscale.enable = true;

    hardware.bluetooth.enable = true;

    environment.systemPackages = with pkgs; [
      vim
      wget
      file
      jq
      unzip
    ];

    users = {
      defaultUserShell = pkgs.zsh;
      users."${config.my.userName}" = {
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

    programs = {
      zsh.enable = true;
      gnupg.agent.enable = true;
      nix-ld.enable = true;
    };

    nix.channel.enable = false;
    nix.settings = {
      substituters = [
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      experimental-features = [
        "flakes"
        "nix-command"
      ];
    };
  };
}
