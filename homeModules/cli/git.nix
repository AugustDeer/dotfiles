{
  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = "August Deer";
          email = "august@augustdeer.com";
        };
        commit.gpgSign = true;
        tag.gpgSign = true;
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
  };
}
