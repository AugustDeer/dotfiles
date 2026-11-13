{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.desktop;

  cursor_shaders = pkgs.fetchFromGitHub {
    owner = "sahaj-b";
    repo = "cursor-shaders";
    rev = "9ad9158a93c0de0c045e1c6b27df37da698bc8af";
    hash = "sha256-TnoQvptwjs6P5/JfJO1CR3yhCfCcaw5wvPr5oEhn4Ho=";
  };
in
{
  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      settings = {
        custom-shader = "${cursor_shaders}/ghostty/cursor_warp.glsl";
        font-family = "FiraCode Nerd Font";
        scrollbar = "never";
        theme = "Kanagawa Wave";
      };
    };
  };
}
