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
      self.homeModules.stylixMango
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

    programs.nixvim = {
      enable = true;

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

  flake.homeModules.stylixMango = {config, ...}: {
    wayland.windowManager.mango = {
      enable = true;
      settings = let
        colors = config.lib.stylix.colors;
      in {
        env = [
          "WLR_DRM_NO_ATOMIC,1"
        ];

        monitorrule = [
          "name:^eDP-1$,width:2560,height:1600,vrr:1,scale:1.25"
        ];

        cursor_size = 32;

        rootcolor = "0x" + colors.base00 + "ff";
        bordercolor = "0x" + colors.base03 + "ff";
        focuscolor = "0x" + colors.base0B + "ff";
        urgentcolor = "0x" + colors.base08 + "ff";

        exec-once = "noctalia";

        trackpad_natural_scrolling = 1;

        bind = [
          "SUPER+SHIFT,R,reload_config"

          "SUPER,RETURN,spawn,kitty"
          "SUPER+SHIFT,Return,spawn,firefox"

          "SUPER,M,quit"
          "SUPER,Q,killclient,"

          "SUPER,TAB,focusstack,next"
          "SUPER,H,focusdir,left"
          "SUPER,L,focusdir,right"
          "SUPER,K,focusdir,up"
          "SUPER,J,focusdir,down"

          "SUPER+SHIFT,H,exchange_client,left"
          "SUPER+SHIFT,L,exchange_client,right"
          "SUPER+SHIFT,K,exchange_client,up"
          "SUPER+SHIFT,J,exchange_client,down"

          "SUPER,G,toggleglobal,"
          "ALT,TAB,togglejump,"
          "SUPER,V,togglefloating,"
          "SUPER,F,togglefullscreen,"
          "SUPER+SHIFT,F,togglefakefullscreen"
          "SUPER,I,minimized"
          "SUPER+SHIFT,I,restore_minimized"
          "SUPER,S,toggle_scratchpad"

          "SUPER,N,switch_layout"

          "SUPER,1,view,1,0"
          "SUPER,2,view,2,0"
          "SUPER,3,view,3,0"
          "SUPER,4,view,4,0"
          "SUPER,5,view,5,0"
          "SUPER,6,view,6,0"
          "SUPER,7,view,7,0"
          "SUPER,8,view,8,0"
          "SUPER,9,view,9,0"

          "SUPER+SHIFT,1,tag,1,0"
          "SUPER+SHIFT,2,tag,2,0"
          "SUPER+SHIFT,3,tag,3,0"
          "SUPER+SHIFT,4,tag,4,0"
          "SUPER+SHIFT,5,tag,5,0"
          "SUPER+SHIFT,6,tag,6,0"
          "SUPER+SHIFT,7,tag,7,0"
          "SUPER+SHIFT,8,tag,8,0"
          "SUPER+SHIFT,9,tag,9,0"

          "SUPER,SPACE,spawn,noctalia msg panel-toggle launcher"
          "SUPER,comma,spawn,noctalia msg settings-toggle"

          "NONE,XF86AudioRaiseVolume,spawn,noctalia msg volume-up"
          "NONE,XF86AudioLowerVolume,spawn,noctalia msg volume-down"
          "NONE,XF86AudioMute,spawn,noctalia msg volume-mute"
          "NONE,XF86MonBrightnessUp,spawn,noctalia msg brightness-up"
          "NONE,XF86MonBrightnessDown,spawn,noctalia msg brightness-down"
        ];

        mousebind = [
          "SUPER,btn_left,moveresize,curmove"
          "SUPER,btn_right,moveresize,curresize"
        ];
      };
    };
  };
}
