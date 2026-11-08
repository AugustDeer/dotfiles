{
  config,
  inputs,
  lib,
  withSystem,
  ...
}:
let
  inherit (builtins) attrNames readDir;

  # All current hosts use this system, so no need for per-host mapping.
  system = "x86_64-linux";

  hostsDir = ../hosts;

  hostNames = attrNames (lib.filterAttrs (_: type: type == "directory") (readDir hostsDir));
in
{
  systems = [ system ];

  flake.nixosConfigurations = withSystem system (
    { pkgs, ... }:
    lib.genAttrs hostNames (
      name:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          config.flake.nixosModules.default
          inputs.disko.nixosModules.disko
          inputs.nixpkgs.nixosModules.readOnlyPkgs
          (hostsDir + "/${name}")
          {
            nixpkgs.pkgs = pkgs;
            networking.hostName = lib.mkDefault name;
          }
        ];
      }
    )
  );
}
