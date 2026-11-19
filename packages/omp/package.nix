/*
  Custom oh-my-pi package using pre-built binary.
  TODO: Delete when https://github.com/can1357/oh-my-pi/issues/10108 is resolved
  (still wrap upstream pkg with chromium)
*/
{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  python3,
  chromium,

  coreutils,
  curl,
  gnused,
  jq,
  nix-update,
  writeShellApplication,
}:
let
  platform =
    {
      x86_64-linux = "linux-x64";
    }
    .${stdenv.hostPlatform.system}
      or (throw "Unsupported platform for omp: ${stdenv.hostPlatform.system}");

  nativeLibraries = [ stdenv.cc.cc.lib ] ++ lib.optional (stdenv.cc.cc ? libgcc) stdenv.cc.cc.libgcc;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "omp";
  version = "19.0.0";

  src = fetchurl {
    url = "https://github.com/can1357/oh-my-pi/releases/download/v${finalAttrs.version}/omp-${platform}";
    hash = "sha256-x8xcjVBQU8j/rxgEF+XVx4EjW52TbyhoEFYBURIBCb8=";
  };

  dontUnpack = true;
  dontStrip = true;
  strictDeps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    python3
  ];

  buildInputs = [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall

    install -Dm755 "$src" "$out/bin/omp"

    runHook postInstall
  '';

  postFixup = ''
    if ! patchelf --print-needed "$out/bin/omp" | grep -qx 'libstdc++\.so\.6'; then
      patchelf --add-needed libstdc++.so.6 "$out/bin/omp"
    fi

    wrapProgram "$out/bin/omp" \
      --set-default OMP_NATIVE_LIBRARY_PATH "${lib.makeLibraryPath nativeLibraries}" \
      --set-default PUPPETEER_EXECUTABLE_PATH "${lib.getExe chromium}"
  '';

  # Must run after patchelf
  preInstallCheck = ''
    python3 ${./fix-dt-verdef.py} "$out/bin/.omp-wrapped"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    mkdir -p "$TMPDIR/home" "$TMPDIR/xdg"

    versionOutput="$(HOME="$TMPDIR/home" XDG_DATA_HOME="$TMPDIR/xdg" "$out/bin/omp" --version)"
    grep -q "${finalAttrs.version}" <<<"$versionOutput"

    smokeOutput="$(HOME="$TMPDIR/home" XDG_DATA_HOME="$TMPDIR/xdg" "$out/bin/omp" --smoke-test)"
    grep -q "smoke-test: ok" <<<"$smokeOutput"

    patchelf --print-needed "$out/bin/.omp-wrapped" | grep -qx 'libstdc++\.so\.6'

    runHook postInstallCheck
  '';

  passthru.updateScript = writeShellApplication {
    name = "update-omp";
    runtimeInputs = [
      coreutils
      curl
      gnused
      jq
      nix-update
    ];
    text = ''
      release="$(curl --fail --silent --show-error --location \
        "https://api.github.com/repos/can1357/oh-my-pi/releases/latest")"

      tag="$(jq --raw-output '.tag_name' <<< "$release")"
      version="''${tag#v}"
      current_version="$(sed --quiet 's/^  version = "\(.*\)";$/\1/p' packages/omp/package.nix)"

      if [[ "$version" == "$current_version" ]]; then
        echo "omp is already up to date at $version"
        exit 0
      fi

      sed --in-place \
        "s|^  version = \".*\";$|  version = \"$version\";|" \
        packages/omp/package.nix

      nix-update --flake --version=skip --src-only omp
    '';
  };

  meta = {
    description = "Terminal-based coding agent with multi-model support";
    homepage = "https://omp.sh";
    changelog = "https://github.com/can1357/oh-my-pi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "omp";
  };
})
