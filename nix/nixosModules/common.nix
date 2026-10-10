{ pkgs, ... }: {
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

  hardware.bluetooth.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    file
    jq
    unzip
  ];

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

  programs.nix-ld.enable = true;

  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];
}
