{
  appimageTools,
  fetchurl,
  runCommand,

  coreutils,
  curl,
  gnused,
  jq,
  nix-update,
  writeShellApplication,
}:
appimageTools.wrapAppImage (finalAttrs: {
  pname = "eden";
  version = "0-unstable-2026-11-07";
  src = fetchurl {
    url = "https://nightly.eden-emu.dev/v1794086134.7f1bc0c9d1/Eden-Linux-7f1bc0c9d1-rog-ally-clang-pgo.AppImage";
    hash = "sha256-cFxIq7OWYVfXsORkURFGGoNhmgtnjUEWRgd3bCwXZU8=";
    executable = true;
  };

  __structuredAttrs = true;
  strictDeps = true;

  contents = runCommand "eden-extracted" { } ''
    ${finalAttrs.src} --appimage-extract
    cp -r AppDir $out
  '';

  extraInstallCommands = /* bash */ ''
    install -m 444 -D ${finalAttrs.contents}/dev.eden_emu.eden.desktop \
      $out/share/applications/dev.eden_emu.eden.desktop
    install -m 444 -D ${finalAttrs.contents}/dev.eden_emu.eden.svg \
      $out/share/icons/hicolor/scalable/apps/dev.eden_emu.eden.svg
  '';

  passthru.updateScript = writeShellApplication {
    name = "update-eden-nightly";
    runtimeInputs = [
      coreutils
      curl
      gnused
      jq
      nix-update
    ];
    text = ''
      release="$(curl --fail --silent --show-error --location \
        "https://git.eden-emu.dev/api/v1/repos/eden-ci/nightly/releases?limit=1")"

      tag="$(jq --raw-output '.[0].tag_name' <<< "$release")"
      timestamp="''${tag#v}"
      timestamp="''${timestamp%%.*}"
      rev="''${tag#*.}"
      version="0-unstable-$(date --utc --date="@$timestamp" +%F)"
      url="https://nightly.eden-emu.dev/$tag/Eden-Linux-$rev-rog-ally-clang-pgo.AppImage"

      current_version="$(sed --quiet 's/^  version = "\(.*\)";$/\1/p' packages/eden-nightly.nix)"

      if [[ "$version" == "$current_version" ]]; then
        echo "eden-nightly is already up to date at $version"
        exit 0
      fi

      sed --in-place \
        -e "s|^  version = \".*\";$|  version = \"$version\";|" \
        -e "s|^    url = \".*\";$|    url = \"$url\";|" \
        packages/eden-nightly.nix

      nix-update --flake --version=skip --src-only eden-nightly
    '';
  };
})
