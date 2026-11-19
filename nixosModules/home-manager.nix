{
  inputs,
  self',
  config,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs self'; };
    users."${config.my.userName}" = {
      imports = [ inputs.self.homeModules.default ];
      home = {
        username = config.my.userName;
        homeDirectory = "/home/${config.my.userName}";
        inherit (config.system) stateVersion;
      };
    };
  };
}
