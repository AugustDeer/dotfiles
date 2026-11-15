{
  appimageTools,
  fetchurl,
}:
appimageTools.wrapType2 (finalAttrs: {
  pname = "eglantine";
  version = "0.1.0-rc4";

  src = fetchurl {
    url = "https://github.com/Djihads80/Eglantine/releases/download/v${finalAttrs.version}/eglantine-linux-x86_64-pgo.AppImage";
    hash = "sha256-5Zk9Dp56ujru5pOQaDj0PsU35HkygN1XLzcS90q68oM=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  extraPkgs = pkgs: [ pkgs.libgpg-error ];

  extraInstallCommands = /* bash */ ''
    install -m 444 -D ${finalAttrs.contents}/dev.eglantine.eglantine.desktop \
      $out/share/applications/dev.eglantine.eglantine.desktop
    install -m 444 -D ${finalAttrs.contents}/dev.eglantine.eglantine.png \
      $out/share/icons/hicolor/512x512/apps/dev.eglantine.eglantine.png
  '';
})
