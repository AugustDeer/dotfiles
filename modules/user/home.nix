{
  inputs,
  self,
  ...
}: {
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.homeConfigurations.adeer = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {system = "x86_64-linux";};
    modules = [
      inputs.nixvim.homeModules.nixvim
      self.homeModules.mango
      self.homeModules.adeerModule
    ];
  };

  flake.homeModules.adeerModule = {
    config,
    pkgs,
    ...
  }: {
    home.username = "adeer";
    home.homeDirectory = "/home/adeer";

    home.stateVersion = "26.05";

    home.packages = with pkgs; [
      wl-clipboard
    ];

    home.pointerCursor = {
      enable = true;
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ-AA";
      gtk.enable = true;
      x11.enable = true;
    };

    programs.home-manager.enable = true;

    xdg.userDirs = {
      enable = true;
      createDirectories = true;
    };

    programs.bash.enable = true;

    programs.starship = {
      enable = true;
      presets = ["nerd-font-symbols"];
    };

    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "August Deer";
          email = "august@augustdeer.com";
        };
      };
    };

    programs.gh.enable = true;

    programs.delta = {
      enable = true;
      enableGitIntegration = true;
    };

    programs.firefox.enable = true;

    programs.kitty = {
      enable = true;
      themeFile = "kanagawa";
    };

    programs.bat = {
      enable = true;
      config = {
        theme = "kanagawa";
      };
      extraPackages = with pkgs.bat-extras; [batman];
      themes = {
        kanagawa = {
          src = "${inputs.kanagawa}/extras/tmTheme/";
          file = "kanagawa.tmTheme";
        };
      };
    };

    home.shellAliases.cat = "bat";

    programs.yazi.enable = true;

    programs.fzf.enable = true;

    programs.ripgrep.enable = true;

    programs.eza = {
      enable = true;
      icons = "auto";
    };

    programs.zoxide = {
      enable = true;
      options = ["--cmd cd"];
    };

    programs.nixvim = {
      enable = true;

      defaultEditor = true;

      colorschemes.kanagawa.enable = true;

      clipboard.providers.wl-copy.enable = true;

      plugins.lspconfig.enable = true;

      lsp.servers = {
        nil_ls.enable = true;
      };
    };

    programs.noctalia = {
      enable = true;

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

    programs.vesktop.enable = true;
  };
}
