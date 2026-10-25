{
  stdenvNoCC,
  fetchzip,
  installFonts,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pixeloperator";
  version = "2018.10.04-1";

  src = fetchzip {
    url = "https://dl.dafont.com/dl/?f=pixel_operator";
    hash = "sha256-NCn3cY9UNsljsljbl+g7qaZy2AA+Br64sLgwytVY3Kg=";
    stripRoot = false;
    extension = "zip";
  };

  nativeBuildInputs = [ installFonts ];
})
