{ inputs, ... }: {
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "kitty";
        source = "${inputs.assets}/pfp_transparent.png";
        height = 21;
        padding.top = 1;
        padding.left = 2;
      };
      display = {
        size = {
          maxPrefix = "MB";
          ndigits = 0;
          spaceBeforeUnit = "never";
        };
        freq = {
          ndigits = 3;
          spaceBeforeUnit = "never";
        };
      };
      modules = [
        "title"
        "separator"
        "os"
        "host"
        {
          "type" = "board";
          "key" = "Host";
          "condition" = {
            "succeeded" = false;
          };
        }
        {
          "type" = "kernel";
          "format" = "{release}";
        }
        "uptime"
        {
          "type" = "packages";
          "combined" = true;
        }
        "shell"
        {
          "type" = "display";
          "compactType" = "original";
          "key" = "Resolution";
        }
        {
          "type" = "de";
          "key" = "DE";
        }
        {
          "type" = "wm";
          "key" = "WM";
        }
        "wmtheme"
        "theme"
        "icons"
        "terminal"
        {
          "type" = "terminalfont";
          "format" = "{/name}{-}{/}{name}{?size} {size}{?}";
        }
        {
          "type" = "cpu";
          "showPeCoreCount" = false;
        }
        {
          "type" = "gpu";
          "key" = "GPU";
          "format" = "{name}";
        }
        {
          "type" = "memory";
          "format" = "{used} / {total}";
        }
        "break"
        "colors"
      ];
    };
  };
}
