{ pkgs, ... }:
let
  cursor_shaders = pkgs.fetchFromGitHub {
    owner = "sahaj-b";
    repo = "cursor-shaders";
    rev = "9ad9158a93c0de0c045e1c6b27df37da698bc8af";
    hash = "sha256-TnoQvptwjs6P5/JfJO1CR3yhCfCcaw5wvPr5oEhn4Ho=";
  };
in
{
  programs.ghostty = {
    enable = true;
    settings = {
      background-opacity = 0.8;
      custom-shader = "${cursor_shaders}/ghostty/cursor_warp.glsl";
      font-family = "FiraCode Nerd Font";
      scrollbar = "never";
      theme = "Kanagawa Wave";
    };
  };
}
