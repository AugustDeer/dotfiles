{
  system ? builtins.currentSystem,
}:
let
  sources = import ./npins;
  pkgs = import sources.nixpkgs { inherit system; };
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    npins
    nh

    nixd
    nixfmt
    statix
    deadnix

    lua-language-server
  ];
}
