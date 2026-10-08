{ inputs, ... }: {
  # Declares the flake.homeConfigurations / flake.homeModules storage options
  # used by the home-manager aspects and the user composition file.
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];
}
