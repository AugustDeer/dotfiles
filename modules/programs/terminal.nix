{
  flake.modules.homeManager.terminal = {
    programs.kitty = {
      enable = true;
      settings = {
        enable_audio_bell = false;
        cursor_trail = 10;
        cursor_trail_decay = "0.05 0.2";
        custom_shaders = "cursor-trail-motion-blur";
      };
    };
  };
}
