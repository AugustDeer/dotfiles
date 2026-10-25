final: prev: {
  my = import ./. {
    pkgs = final;
    inherit (prev) lib;
  };
}
