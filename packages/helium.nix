{ appimageTools, fetchurl }:
appimageTools.wrapType2 (finalAttrs: {
  pname = "helium";
  version = "0.20.3.1";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${finalAttrs.version}/helium-${finalAttrs.version}-x86_64.AppImage";
    hash = "sha256-H69Thkj+FKHqkuMlyxI4rojEeGZsteY9DSrxcP5MoDc=";
  };

  extraInstallCommands = /* bash */ ''
    install -m 444 -D ${finalAttrs.contents}/helium.desktop $out/share/applications/helium.desktop
    install -m 444 -D ${finalAttrs.contents}/usr/share/icons/hicolor/256x256/apps/helium.png \
      $out/share/icons/hicolor/256x256/apps/helium.png
  '';
})
