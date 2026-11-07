{ inputs, ... }: {
  perSystem =
    { lib, system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "nvidia-x11"
            "nvidia-settings"

            "steam"
            "steam-unwrapped"
          ];
      };
    };
}
