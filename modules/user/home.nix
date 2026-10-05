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
      inputs.stylix.homeModules.stylix
      inputs.mangowm.hmModules.mango
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

    home.pointerCursor = {
      enable = true;
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ-AA";
      gtk.enable = true;
      x11.enable = true;
    };

    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";
      polarity = "dark";
      targets.noctalia.enable = false; # Use the official kanagawa theme
      targets.nixvim.enable = false; # Use the official kanagawa theme
      targets.firefox.enable = false;
    };

    programs.home-manager.enable = true;

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

    programs.firefox.enable = true;

    programs.kitty.enable = true;

    programs.bat.enable = true;

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
        widget.clock = {
          format = "{:%-I:%M %p}";
        };
      };
    };
  };
}
