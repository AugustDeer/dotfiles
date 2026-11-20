{
  appimageTools,
  fetchurl,
  runCommand,

  coreutils,
  curl,
  gnused,
  jq,
  nix,
  writeShellApplication,
}:
appimageTools.wrapAppImage (finalAttrs: {
  pname = "eden";
  version = "0-unstable-2026-11-17";
  src = fetchurl {
    url = "https://nightly.eden-emu.dev/v1794878467.d85bad8924/Eden-Linux-d85bad8924-rog-ally-clang-pgo.AppImage";
    hash = "sha256-B1IKJbMXxCk9gdbUivx/iWy+dDRWdq10ES4RHmDmYbk=";
    executable = true; # necessary so --appimage-extract works
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
      nix
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

      hash="$(nix store prefetch-file --executable --hash-type sha256 --json "$url" | jq --raw-output .hash)"

      sed --in-place \
        -e "s|^  version = \".*\";$|  version = \"$version\";|" \
        -e "s|^    url = \".*\";$|    url = \"$url\";|" \
        -e "s|^    hash = \".*\";$|    hash = \"$hash\";|" \
        packages/eden-nightly.nix
    '';
  };
})
