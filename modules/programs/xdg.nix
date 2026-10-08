{
  flake.modules.homeManager.xdg = {
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
