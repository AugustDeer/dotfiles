{
  appimageTools,
  fetchurl,
}:
let
  tag = "build-131";
  rev = "ce1b1de6f1beed36958368f89cda466937ff9716";
in
appimageTools.wrapType2 (finalAttrs: {
  pname = "eglantine";
  version = "0-${tag}";

  src = fetchurl {
    url = "https://github.com/Djihads80/Eglantine/releases/download/${tag}/eglantine-${rev}-linux-x86_64-pgo.AppImage";
    hash = "sha256-wESxkF/XZKJSWuUOHc4Fg8iV7gBa1AoKRbfv4ifmxF4=";
  };

  extraPkgs = pkgs: [ pkgs.libgpg-error ];

  extraInstallCommands = /* bash */ ''
    install -m 444 -D ${finalAttrs.contents}/dev.eden_emu.eden.desktop \
      $out/share/applications/dev.eglantine.eglantine.desktop
    install -m 444 -D ${finalAttrs.contents}/dev.eglantine.eglantine.png \
      $out/share/icons/hicolor/512x512/apps/dev.eglantine.eglantine.png
  '';
})
