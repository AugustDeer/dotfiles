{ inputs, pkgs, ... }:
let
  inherit (pkgs) stdenv runCommand installShellFiles;
  base = inputs.llm-agents.packages.${stdenv.hostPlatform.system}.opencode2;
  opencode =
    runCommand "opencode-${base.version}"
      {
        nativeBuildInputs = [ installShellFiles ];
        meta = base.meta // {
          mainProgram = "opencode";
        };
      }
      ''
        mkdir -p $out/bin
        ln -s ${base}/bin/opencode2 $out/bin/opencode

        export HOME=$TMPDIR
        installShellCompletion --cmd opencode \
          --bash <($out/bin/opencode --completions bash) \
          --fish <($out/bin/opencode --completions fish) \
          --zsh <($out/bin/opencode --completions zsh)
      '';
in
{
  home.packages = [ opencode ];
}
