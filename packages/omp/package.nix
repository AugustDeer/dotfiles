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
  nix,
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
  version = "19.2.1";

  src = fetchurl {
    url = "https://github.com/can1357/oh-my-pi/releases/download/v${finalAttrs.version}/omp-${platform}";
    hash = "sha256-6Lk3+b8CO6oUe90wCtVCGvCm74sfNQxHqak9X8qU/so=";
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

  # These hooks must run after patchelf and autoPatchelf. The standard postFixup
  # block fires before external postFixupHooks, so these functions are injected
  # into the array during preFixup.
  preFixup = ''
    _ompFixDtVerdef() {
      python3 ${./fix-dt-verdef.py} "$out/bin/.omp-wrapped"
    }

    _ompInstallCompletions() {
      mkdir -p "$TMPDIR/home" "$TMPDIR/xdg"
      HOME="$TMPDIR/home" XDG_DATA_HOME="$TMPDIR/xdg" "$out/bin/omp" completions bash > "$TMPDIR/omp.bash"
      HOME="$TMPDIR/home" XDG_DATA_HOME="$TMPDIR/xdg" "$out/bin/omp" completions zsh > "$TMPDIR/_omp"
      HOME="$TMPDIR/home" XDG_DATA_HOME="$TMPDIR/xdg" "$out/bin/omp" completions fish > "$TMPDIR/omp.fish"

      install -Dm444 "$TMPDIR/omp.bash" "$out/share/bash-completion/completions/omp"
      install -Dm444 "$TMPDIR/_omp" "$out/share/zsh/site-functions/_omp"
      install -Dm444 "$TMPDIR/omp.fish" "$out/share/fish/vendor_completions.d/omp.fish"
    }

    postFixupHooks+=(_ompFixDtVerdef _ompInstallCompletions)
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

    for completion in \
      "$out/share/bash-completion/completions/omp" \
      "$out/share/zsh/site-functions/_omp" \
      "$out/share/fish/vendor_completions.d/omp.fish"; do
      test -s "$completion"
    done

    runHook postInstallCheck
  '';

  passthru.updateScript = writeShellApplication {
    name = "update-omp";
    runtimeInputs = [
      coreutils
      curl
      gnused
      jq
      nix
    ];
    text = ''
      release="$(curl --fail --silent --show-error --location \
        "https://api.github.com/repos/can1357/oh-my-pi/releases/latest")"

      tag="$(jq --raw-output '.tag_name' <<< "$release")"
      version="''${tag#v}"
      url="https://github.com/can1357/oh-my-pi/releases/download/v$version/omp-linux-x64"
      current_version="$(sed --quiet 's/^  version = "\(.*\)";$/\1/p' packages/omp/package.nix)"

      if [[ "$version" == "$current_version" ]]; then
        echo "omp is already up to date at $version"
        exit 0
      fi

      hash="$(nix store prefetch-file --hash-type sha256 --json "$url" | jq --raw-output .hash)"

      sed --in-place \
        -e "s|^  version = \".*\";$|  version = \"$version\";|" \
        -e "s|^    hash = \".*\";$|    hash = \"$hash\";|" \
        packages/omp/package.nix
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
