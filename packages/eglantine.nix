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
  tag = "daily-20261107";
in
appimageTools.wrapType2 (finalAttrs: {
  pname = "eglantine";
  version = "0-${tag}";

  src = fetchurl {
    url = "https://github.com/Djihads80/Eglantine/releases/download/${tag}/eglantine-linux-x86_64-pgo.AppImage";
    hash = "sha256-hhhUCpKajK0hHon/AksOIyO948dp4lD0+iatJ18jhsc=";
  };

  __structuredAttrs = true;
  strictDeps = true;

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

      current_tag="$(sed --quiet 's/^  tag = "\(.*\)";$/\1/p' packages/eglantine.nix)"

      if [[ "$tag" == "$current_tag" ]]; then
        echo "eglantine is already up to date at $tag"
        exit 0
      fi

      sed --in-place \
        -e "s|^  tag = \".*\";$|  tag = \"$tag\";|" \
        packages/eglantine.nix

      nix-update --flake --version=skip --src-only eglantine
    '';
  };
})
