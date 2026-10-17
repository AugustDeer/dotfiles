# My Nix Configuration

This is my personal Nix flake for NixOS, Home-Manager and related services. It
currently serves one user (myself, August Deer) and one machine, but more
machines are planned to be added in the future.

## Features

- Wayland shell with [MangoWM](https://github.com/mangowm/mango) and
  [Noctalia](https://github.com/noctalia-dev/noctalia).
- Custom [Neovim](https://github.com/neovim/neovim) configuration powered by
  [nvf](https://github.com/NotAShelf/nvf).
- Various cli utilities: [bat](https://github.com/sharkdp/bat),
  [yazi](https://github.com/sxyazi/yazi),
  [eza](https://github.com/eza-community/eza), etc.
- Everything else I use on a day-to-day basis.

## Usage

I primarily use the [nh](https://github.com/nix-community/nh) Nix CLI helper for
deployment. If `nh` is not installed, bring it into the environment with one of
the following commands:

```sh
nix shell nixpkgs#nh # with flakes
nix-shell -p nh      # without flakes
```

Deploy the os configuration with one of the following commands:

```sh
nh os switch . # build and activate the current NixOS configuration
nh os boot .   # build current NixOS configuration and prepare for reboot
```

This is a nix flake, so inputs are pinned and not updated by default. To update
nixpkgs and other inputs, include the `--update` flag. Also include
`--commit-lock-file` to commit the updated inputs.

> [!CAUTION]
> Nix ignores files which are untracked by git. `git add` any new files before rebuilding.

## Layout

- `packages/`: Custom packages not currently in upstream nixpkgs. Packages are
  auto-imported and overlayed onto nixpkgs, available under `pkgs.<name>`.
  Single-file packages are imported from `<name>.nix`, multi-file packages (none
  at the moment) are imported from `<name>/package.nix`.
- `nixosModules/`: Reusable system configurations. Either import `common.nix`
  for base system config, or `desktop.nix` for additional gui-specific settings.
- `nixosConfigurations/`: Device-specific system configuration. Each host is
  auto-imported from `<hostname>/default.nix`.
- `homeModules/`: User configuration via Home-Manager. Imported as a NixOS
  module, so not necessary to use directly.
- `assets/`: Non-nix assets.

## Adding a New Machine

Create a new default configuration with this command:

```sh
nixos-generate-config --dir ./nixosConfigurations/<hostname>/
```

This will create a default `configuration.nix` and `hardware-configuration.nix`.
Rename `configuration.nix` to `default.nix` so it is imported correctly, and
make any desired changes. Ensure you import `nixosModules/common.nix` or
`nixosModules/desktop.nix` to use the common configuration options, and include
the home-manager NixOS module for user dotfiles and programs.

> [!NOTE]
> Remember to `git add` all new files, and commit + push your changes.

Finally, deploy the configuration with

```sh
nh os boot . -H <hostname>
```

and reboot to enjoy your new NixOS install.

## AI Usage

Portions of this configuration were written with LLM assistance (primarily via
the [opencode](https://github.com/anomalyco/opencode) agent). At all points, the
goal is my own education. No code has been committed which I myself do not
understand and cannot explain.
