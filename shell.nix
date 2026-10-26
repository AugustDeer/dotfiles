{
  system ? builtins.currentSystem,
}:
let
  sources = import ./npins;
  pkgs = import sources.nixpkgs { inherit system; };
  pre-commit = (import sources."git-hooks.nix").run {
    src = ./.;
    hooks = {
      nixfmt.enable = true;
      statix.enable = true;
      deadnix.enable = true;
    };
  };
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

  inherit (pre-commit) shellHook;
}
