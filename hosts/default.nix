{
  config,
  inputs,
  withSystem,
  ...
}:
let
  mkHost =
    system: module:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        config.flake.nixosModules.default
        module
        { nixpkgs.pkgs = withSystem system ({ pkgs, ... }: pkgs); }
      ];
    };
in
{
  flake.nixosConfigurations = {
    augustROG = mkHost "x86_64-linux" ./augustROG;
  };
}
