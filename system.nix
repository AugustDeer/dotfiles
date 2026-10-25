let
  sources = import ./npins;

  lib = import "${sources.nixpkgs}/lib";

  # Absolute path to root config directory, for mkOutOfStoreSymlink.
  src = "/home/adeer/dotfiles";

  hostsDir = ./hosts;
  hosts = builtins.attrNames (
    lib.filterAttrs (_: type: type == "directory") (builtins.readDir hostsDir)
  );

  mkConfig = name: { lib, ... }: {
    imports = [
      ./nixosModules
      (hostsDir + "/${name}")
    ];

    networking.hostName = lib.mkDefault name;

    nix = {
      channel.enable = false;
      nixPath = lib.mkDefault [ "nixos-system=${src}/system.nix" ];
    };

    nixpkgs = {
      config.allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "nvidia-x11"
          "nvidia-settings"

          "steam"
          "steam-unwrapped"
        ];
      overlays = [ (import ./overlay.nix) ];
      flake.source = sources.nixpkgs;
    };
  };

  mkHost =
    name:
    import "${sources.nixpkgs}/nixos" {
      system = null;
      specialArgs = { inherit src sources; };
      configuration = mkConfig name;
    };
in
lib.genAttrs hosts mkHost
