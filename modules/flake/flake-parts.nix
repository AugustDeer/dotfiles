{ inputs, ... }: {
  # Declares the flake.modules.<class>.<aspect> option used by dendritic modules.
  imports = [
    inputs.flake-parts.flakeModules.modules
  ];
}
