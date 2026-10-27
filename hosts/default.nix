{
  self,
  nixpkgs,
  pkgsFor,
  src,
  ...
}@inputs:
let
  inherit (nixpkgs.lib) nixosSystem;
  mkHost =
    system: module:
    nixosSystem {
      specialArgs = { inherit inputs src; };
      modules = [
        self.nixosModules.default
        module
        {
          nixpkgs.pkgs = pkgsFor system;
        }
      ];
    };
in
{
  augustROG = mkHost "x86_64-linux" ./augustROG;
}
