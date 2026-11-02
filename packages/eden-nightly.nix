{
  appimageTools,
  fetchurl,
  runCommand,
}:
appimageTools.wrapAppImage (finalAttrs: {
  pname = "eden";
  version = "0-unstable-2026-11-01";
  src = fetchurl {
    url = "https://nightly.eden-emu.dev/v1793569440.7a6d055094/Eden-Linux-7a6d055094-rog-ally-clang-pgo.AppImage";
    hash = "sha256-szJOM+WRAqzLk5ALfWL2jynIvhFAx7aV0lP53Azg94o=";
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
