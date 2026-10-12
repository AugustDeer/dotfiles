{ pkgs, flake, ... }: {
  imports = [ ./neovim.nix ];

  home.packages = [
    pkgs.wl-clipboard
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.shellAliases.cat = "bat";

  programs = {
    bash.enable = true;
    zsh.enable = true;

    starship = {
      enable = true;
      presets = [ "nerd-font-symbols" ];
    };

    fastfetch = {
      enable = true;
      settings = {
        logo = {
          type = "kitty";
          source = flake.src + "/assets/pfp_transparent.png";
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

    git = {
      enable = true;
      settings = {
        user = {
          name = "August Deer";
          email = "august@augustdeer.com";
        };
      };
    };
    gh.enable = true;
    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        side-by-side = true;
      };
    };
    lazygit.enable = true;

    bat.enable = true;

    yazi.enable = true;

    fzf.enable = true;

    ripgrep.enable = true;

    eza = {
      enable = true;
      icons = "auto";
    };

    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };

    opencode = {
      enable = true;
      tui.theme = "kanagawa";
    };

    pi-coding-agent.enable = true;

    nh = {
      enable = true;
      flake = "/home/adeer/dotfiles";
    };
  };
}
