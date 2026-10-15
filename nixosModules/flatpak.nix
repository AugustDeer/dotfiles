{
  services.flatpak.enable = true;

  home-manager.sharedModules = [
    {
      xdg.systemDirs.data = [
        "/usr/share"
        "/var/lib/flatpak/exports/share"
        "$HOME/.local/share/flatpak/exports/share"
      ];
    }
  ];
}
