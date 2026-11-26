{
  lib,
  stdenv,
  requireFile,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  glib,
  glib-networking,
  gsettings-desktop-schemas,
  gst_all_1,
  libglvnd,
  libxkbcommon,
  openssl,
  perf,
  pipewire,
  vulkan-loader,
  wayland,
  webkitgtk_4_1,
  zenity,
}:
let
  system = "x86_64-linux";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "tern";
  version = "0.9.35";

  # Tern is distributed through a private waitlist; each archive is added to the store by hand.
  src = requireFile {
    name = "tern-${system}.tar.gz";
    hash = "sha256-+D6UEiBHdn2kKvCh/chVu/fztq2PGv7kFuqleicTw8I=";
    message = ''
      Download the Tern ${finalAttrs.version} ${system} archive, then add it to the Nix store with:

        nix store prefetch-file file:///path/to/archive.tar.gz --name tern-${system}.tar.gz
    '';
  };

  sourceRoot = "tern";
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];
  buildInputs = [
    openssl
    (lib.getLib stdenv.cc.cc)
  ];

  # Tern self-registers a desktop entry pointing directly at this ELF, bypassing
  # $out/bin/tern. Keep its dlopen() dependencies, including WebKit, in the ELF's RUNPATH.
  runtimeDependencies = [
    libglvnd
    libxkbcommon
    pipewire
    vulkan-loader
    wayland
    webkitgtk_4_1
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "so.stencil.tern";
      desktopName = "Tern";
      genericName = "Terminal Emulator";
      comment = "Multiplexing terminal";
      exec = "tern %F";
      icon = "so.stencil.tern";
      categories = [
        "System"
        "TerminalEmulator"
      ];
      mimeTypes = [
        "text/plain"
        "text/markdown"
        "text/x-source"
        "image/png"
        "image/jpeg"
        "image/gif"
        "image/webp"
        "image/svg+xml"
      ];
      extraConfig.StartupWMClass = "so.stencil.tern";
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/tern
    install -Dm755 tern $out/lib/tern/tern
    # WebKit needs GIO's TLS backend and desktop schemas; without the latter,
    # GTK reports -1 DPI on Wayland, breaking page geometry and font sizing.
    makeWrapper "$out/lib/tern/tern" "$out/bin/tern" \
      --prefix PATH : "${
        lib.makeBinPath [
          glib
          zenity
          perf
        ]
      }" \
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${lib.getLib gst_all_1.gst-plugins-base}/lib/gstreamer-1.0" \
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}"

    runHook postInstall
  '';

  postInstall = ''
    autoPatchelf "$out/lib/tern/tern"

    export HOME="$TMPDIR/tern-home"
    export XDG_DATA_HOME="$TMPDIR/tern-data"
    mkdir -p "$HOME" "$XDG_DATA_HOME" "$out/share"

    "$out/lib/tern/tern" register
    cp -r "$XDG_DATA_HOME/icons" "$out/share/"
  '';

  meta = {
    description = "A neoterminal for the Electron-weary";
    homepage = "https://stencil.so/tern";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ system ];
    mainProgram = "tern";
  };
})
