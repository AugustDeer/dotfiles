{
  sources,
  config,
  src,
  ...
}:
{
  imports = [ "${sources.home-manager}/nixos" ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit src; };
    users."${config.my.userName}" = {
      imports = [ ../homeModules ];
      home = {
        username = config.my.userName;
        homeDirectory = "/home/${config.my.userName}";
        inherit (config.system) stateVersion;
      };
    };
  };
}
