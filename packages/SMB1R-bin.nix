{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeBinaryWrapper,
  copyDesktopItems,
  makeDesktopItem,
  unzip,
  gccNGPackages,
  libxkbcommon,
  libx11,
  libxcursor,
  libxext,
  libxfixes,
  libxi,
  libxinerama,
  libxrandr,
  libxrender,
  libGL,
  fontconfig,
  libpulseaudio,
}: let
  inherit (gccNGPackages) libstdcxx;
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "SMB1R-bin";
    version = "1.1-stable";
    src = fetchurl {
      url = "https://github.com/JHDev2006/Super-Mario-Bros.-Remastered-Public/releases/download/${finalAttrs.version}/Linux.zip";
      hash = "sha256-EuwkE3Nbj8g86FCE7BJoUrH5IlWc0BPSexCdJGO1vNc=";
    };
    nativeBuildInputs = [
      autoPatchelfHook
      makeBinaryWrapper
      copyDesktopItems
      unzip
    ];
    buildInputs = [
      libstdcxx
    ];
    runtimeDependencies = [
      libxkbcommon
      libx11
      libxcursor
      libxext
      libxfixes
      libxi
      libxinerama
      libxrandr
      libxrender
      libGL
      fontconfig
      libpulseaudio
    ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      mkdir -p $out/lib/$pname/
      cp ./SMB1R* $out/lib/$pname/
      cp ./*.so $out/lib/$pname/
      makeWrapper $out/lib/$pname/SMB1R.x86_64 $out/bin/SMB1R --set GLIBC_TUNABLES glibc.rtld.execstack=2
      runHook postInstall
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "SMB1R";
        desktopName = "Super Mario Bros. Remastered";
        comment = "Remake / Celebration of the original 'Super Mario Bros.' games";
        exec = "SMB1R";
        categories = [
          "Game"
          "ActionGame"
        ];
        keywords = [
          "Mario"
          "Bros"
          "Remastered"
          "Remake"
          "Godot"
        ];
        icon = fetchurl {
          url = "https://raw.githubusercontent.com/JHDev2006/Super-Mario-Bros.-Remastered-Public/${finalAttrs.version}/icon.png";
          hash = "sha256-/PZoiX/d8NqxnB7TdqG2qUCD+0KfnoeQAgLmN1aTF48=";
        };
      })
    ];

    meta = {
      description = "Remake / Celebration of the original 'Super Mario Bros.' games";
      homepage = "https://github.com/JHDev2006/Super-Mario-Bros.-Remastered-Public";
      downloadPage = "https://github.com/JHDev2006/Super-Mario-Bros.-Remastered-Public/releases";
      license = lib.licenses.gpl3Only;
      sourceProvenance = lib.sourceTypes.binaryNativeCode;
      mainProgram = "SMB1R";
      platforms = ["x86_64-linux"];
    };
  })
