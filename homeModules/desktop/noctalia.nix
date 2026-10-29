{ pkgs, ... }:

let
  # Dependencies for Wallpaper Depth plugin
  wrapped-python = pkgs.python314.withPackages (
    ps: with ps; [
      numpy
      onnxruntime
      pillow
    ]
  );
  wrapped-noctalia = pkgs.symlinkJoin {
    inherit (pkgs.noctalia) version meta;
    pname = "noctalia-wrapped";
    buildInputs = [ pkgs.makeBinaryWrapper ];
    paths = [ pkgs.noctalia ];
    postBuild = ''
      wrapProgram $out/bin/noctalia \
        --prefix PATH : ${pkgs.lib.makeBinPath [ wrapped-python ]}
    '';
  };
in
{
  programs.noctalia = {
    enable = true;

    package = wrapped-noctalia;

    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Kanagawa";
      };
      widget.clock = {
        format = "{:%-I:%M %p}";
      };
    };
  };
}
