{
  pkgs ? import (import ./.tack).nixpkgs { },
}:
pkgs.lib.packagesFromDirectoryRecursive {
  inherit (pkgs) callPackage;
  directory = ./packages;
}
