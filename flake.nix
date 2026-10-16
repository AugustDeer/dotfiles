{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    llm-agents,
    ...
  }: let
    inherit (nixpkgs) lib;
    systems = ["x86_64-linux"];
    forAllSystems = lib.genAttrs systems;

    # Flake-wide nixpkgs policy, shared by the flake's own outputs and by
    # every NixOS configuration.
    nixpkgsConfig = {
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "nvidia-x11"
          "nvidia-settings"

          "steam"
          "steam-unwrapped"
        ];
    };

    pkgsFor = system:
      import nixpkgs {
        inherit system;
        config = nixpkgsConfig;
      };

    myOverlay = final: _prev: {
      SMB1R-bin = final.callPackage ./packages/SMB1R-bin.nix {};
    };

    nixosOverlays = [
      myOverlay
      llm-agents.overlays.shared-nixpkgs
    ];
  in {
    packages = forAllSystems (
      system: let
        pkgs = (pkgsFor system).extend myOverlay;
      in {
        inherit (pkgs) SMB1R-bin;
      }
    );

    formatter = forAllSystems (system: (pkgsFor system).alejandra);

    nixosConfigurations.augustROG = lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./nixosConfigurations/augustROG
        {
          nixpkgs.config = nixpkgsConfig;
          nixpkgs.overlays = nixosOverlays;
        }
      ];
    };
  };
}
