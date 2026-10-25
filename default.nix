{
  system ? builtins.currentSystem,
  sources ? import ./npins,
  pkgs ? import sources.nixpkgs { inherit system; },
  lib ? pkgs.lib,
}:
lib.packagesFromDirectoryRecursive {
  inherit (pkgs) callPackage;
  directory = ./packages;
}
