{
  appimageTools,
  fetchurl,
  runCommand,
}:
appimageTools.wrapAppImage (finalAttrs: {
  pname = "eden";
  version = "0-unstable-2026-10-18";
  src = fetchurl {
    url = "https://nightly.eden-emu.dev/v1792353251.de7e6e01d4/Eden-Linux-de7e6e01d4-rog-ally-clang-pgo.AppImage";
    hash = "sha256-3vPBMXMjZm6c1JIHZJeJSj1dPCnv9HEJQ0JahLxepps=";
    executable = true;
  };

  contents = runCommand "eden-extracted" { } ''
    ${finalAttrs.src} --appimage-extract
    cp -r AppDir $out
  '';

  extraInstallCommands = /* bash */ ''
    install -m 444 -D ${finalAttrs.contents}/dev.eden_emu.eden.desktop $out/share/applications/dev.eden_emu.eden.desktop
    install -m 444 -D ${finalAttrs.contents}/dev.eden_emu.eden.svg $out/share/icons/hicolor/scalable/apps/dev.eden_emu.eden.svg
  '';
})
