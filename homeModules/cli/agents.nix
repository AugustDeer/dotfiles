{
  config,
  lib,
  pkgs,
  inputs,
  self',
  ...
}:
let
  cfg = config.my.shell;
  llmPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  options.my.shell.agents = (lib.mkEnableOption "coding agents") // {
    default = true;
  };

  config = lib.mkIf (cfg.enable && cfg.agents) {
    home.packages = [
      pkgs.chromium

      llmPkgs.omp
      pkgs.opencode
      llmPkgs.pi
      self'.packages.tern
    ];
  };
}
