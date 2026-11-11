{ inputs, ... }: {
  perSystem = { system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfreePackages = [
        "nvidia-x11"
        "nvidia-settings"

        "steam"
        "steam-unwrapped"
      ];
    };
  };
}
