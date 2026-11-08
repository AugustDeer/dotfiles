# My Nix Configuration

This is my personal Nix flake for NixOS, Home-Manager and related services. It
currently serves one user (myself, August Deer) and one machine, but more
machines are planned to be added in the future.

## Features

- Wayland shell with [Hyprland](https://github.com/hyprwm/Hyprland) and
  [Noctalia](https://github.com/noctalia-dev/noctalia).
- Custom [Neovim](https://github.com/neovim/neovim) configuration.
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
nh os switch # build and activate the current NixOS configuration
nh os boot   # build current NixOS configuration and prepare for reboot
```

This is a nix flake, so inputs are pinned and not updated by default. To update
nixpkgs and other inputs, include the `--update` flag. Also include
`--commit-lock-file` to commit the updated inputs.

> [!CAUTION]
> Nix ignores files which are untracked by git. `git add` any new files before
> rebuilding.

## Layout

- `assets/`: Non-nix assets.
- `config/`: Non-nix configuration.
- `flakeModules/`: flake-parts modules for wiring up flake outputs.
- `homeModules/`: User configuration via Home-Manager. Imported as a NixOS
  module, so not necessary to use directly.
- `hosts/`: Device-specific system configuration. Each host is auto-imported
  from `hosts/<hostname>/default.nix`. (Currently, all hosts are assumed to be
  of type `x86_64-linux`.)
- `nixosModules/`: Reusable system modules. Auto-imported into each NixOS
  configuration.
- `packages/`: Custom packages not currently in upstream nixpkgs. Packages are
  auto-imported and reexported as `flake.packages.<system>.<name>`. Single-file
  packages are imported from `packages/<name>.nix`, multi-file packages (none
  at the moment) are imported from `packages/<name>/package.nix`.

## Adding a New Machine

Create a new default configuration with this command:

```sh
nixos-generate-config --dir ./hosts/<hostname>/ --no-filesystems
```

This will create a default `configuration.nix` and `hardware-configuration.nix`.
Rename `configuration.nix` to `default.nix` so it is imported correctly, and
make any desired changes.

This repo uses [disko](https://github.com/nix-community/disko) for managing
partitions and filesystems. Reference an existing `disko.nix`, or a file
from the disko
[examples folder](https://github.com/nix-community/disko/tree/latest/example),
while configuring.

Note that most settings in `configuration.nix` can be deleted: the hostname
is automatically set based on the folder name, and sensible defaults are
automatically set by `./nixosModules/common.nix`. Set `my.desktop.enable = true;`
for gui-specific tools.

> [!NOTE]
> Remember to `git add` all new files, and commit + push your changes.

Finally, deploy the configuration with

```sh
sudo nix run 'github:nix-community/disko/latest#disko-install' -- \
  --flake .#<hostname> \
  --disk <disk-name> <disk-device>
```

and reboot to enjoy your new NixOS install.

## AI Usage

Portions of this configuration were written with LLM assistance (primarily via
the [pi](https://pi.dev) agent). At all points, the goal is my own education.
No code has been committed which I myself do not understand and cannot explain.

All documentation (including this README) is human-written.
