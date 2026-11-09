{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  cfg = config.my.desktop;
in
{
  options.my.desktop.enable = (lib.mkEnableOption "desktop/gui-specific settings") // {
    default = osConfig.my.desktop.enable;
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      wl-clipboard
      inkscape

      proton-vpn
    ];

    home.file.".face".source = ../../assets/pfp.png;

    xdg = {
      userDirs = {
        enable = true;
        createDirectories = true;
      };
      configFile."xfce4/helpers.rc".text = ''
        TerminalEmulator=kitty
      '';
    };

    programs = {
      kitty = {
        enable = true;
        themeFile = "kanagawa";
        settings = {
          font_family = "FiraCode Nerd Font";
          background_opacity = 0.8;
          enable_audio_bell = false;
          cursor_trail = 10;
          cursor_trail_decay = "0.05 0.2";
          custom_shaders = "cursor-trail-motion-blur";
        };
      };

      firefox.enable = true;

      keepassxc.enable = true;

      vesktop.enable = true;
    };

    services.syncthing = {
      enable = true;
    };
  };
}
