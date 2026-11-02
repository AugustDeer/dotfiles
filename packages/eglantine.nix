{
  appimageTools,
  fetchurl,

  coreutils,
  curl,
  gnused,
  jq,
  nix-update,
  writeShellApplication,
}:
let
  tag = "build-142";
in
appimageTools.wrapType2 (finalAttrs: {
  pname = "eglantine";
  version = "0-${tag}";

  src = fetchurl {
    url = "https://github.com/Djihads80/Eglantine/releases/download/build-142/eglantine-linux-x86_64-pgo.AppImage";
    hash = "sha256-Xy91BeLOaGR6oMf4M/obcKWsxg1eWhkwvHeqeuiZK/w=";
  };

  extraPkgs = pkgs: [ pkgs.libgpg-error ];

  extraInstallCommands = /* bash */ ''
    install -m 444 -D ${finalAttrs.contents}/dev.eden_emu.eden.desktop \
      $out/share/applications/dev.eglantine.eglantine.desktop
    install -m 444 -D ${finalAttrs.contents}/dev.eglantine.eglantine.png \
      $out/share/icons/hicolor/512x512/apps/dev.eglantine.eglantine.png
  '';

  passthru.updateScript = writeShellApplication {
    name = "update-eglantine";
    runtimeInputs = [
      coreutils
      curl
      gnused
      jq
      nix-update
    ];
    text = ''
      release="$(curl --fail --silent --show-error --location \
        "https://api.github.com/repos/Djihads80/Eglantine/releases?per_page=1")"

      tag="$(jq --raw-output '.[0].tag_name' <<< "$release")"
      url="$(jq --raw-output '
        .[0].assets[]
        | select(.name | test("^eglantine-linux-x86_64-pgo[.]AppImage$"))
        | .browser_download_url
      ' <<< "$release")"

      current_tag="$(sed --quiet 's/^  tag = "\(.*\)";$/\1/p' packages/eglantine.nix)"

      if [[ "$tag" == "$current_tag" ]]; then
        echo "eglantine is already up to date at $tag"
        exit 0
      fi

      sed --in-place \
        -e "s|^  tag = \".*\";$|  tag = \"$tag\";|" \
        -e "s|^    url = \".*\";$|    url = \"$url\";|" \
        packages/eglantine.nix

      nix-update --version=skip --src-only eglantine
    '';
  };
})
