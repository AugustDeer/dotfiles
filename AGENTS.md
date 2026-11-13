# Agent Guidelines

## Human-Written Documentation

All documentation in this repository is written by a human, without exception:
README files, code comments, and Nix option `description` strings included.

The purpose is not tidiness. The user edits this configuration by hand and will
not rely on agents for every change. When a feature is rewritten by a human, its
documentation has to reflect that human's way of thinking, which prose written
by an agent does not. Prose you write now becomes a liability later.

When a change would benefit from documentation, do not write it yourself. Tell
the user what is missing and let them write it in their own words.

This applies to prose only, not to code. Renaming an attribute, changing a
default, adding an option, or removing a capability is your job. Describing that
change is not.

Because you will not be maintaining the prose, watching for drift is part of
your job. When your edit makes existing documentation false, incomplete, or
misleading, stop and report it: name the file, quote the stale passage, and
explain what changed. Flag drift when you introduce it, not in a summary at the
end. Never leave stale documentation behind silently, and never quietly rewrite
it.

Exception: AGENTS.md, SKILL.md, and other text whose primary reader is an agent.

## Ask, Don't Assume

The user is an active participant in the development process, not a silent
observer. If you encounter a roadblock (e.g. a missing file, incorrect
permissions, unclear instructions), stop, explain the issue, and ask for
clarification. Do not waste thousands of tokens on a problem that could be
solved with a single question.

This includes failures that are not obvious in the code. If you cannot build,
evaluate, or otherwise verify your change, say so plainly. Never report work as
complete or correct on the assumption that it would have worked.

## Verifying Changes

Evaluate and instantiate without building or activating:

    nix build --dry-run .#nixosConfigurations.<host>.config.system.build.toplevel

This catches typos, bad option names and unknown packages in a few seconds. For
a single option:

    nix eval .#nixosConfigurations.<host>.config.<option.path>

Format with `nix fmt`. Never run `nh os switch`, `nixos-rebuild switch`, or
anything that activates a generation: the root filesystem is LUKS-encrypted and
activation requires the user's passphrase and modifies the bootloader. Build
only, and report the result.

## Git

Never commit, amend, rebase, push, or otherwise modify history. The user
commits, always. Staging is the exception: `git add` is often required, because
Nix ignores files which git does not track.

## Proportional Changes

Make the smallest change that satisfies the request. Do not refactor unrelated
modules, reorganize the tree, add packages or devshell tools, or upgrade inputs
opportunistically. If a larger change is warranted, describe it and ask first.

## Repository Conventions

Read `README.md`, especially the Layout section, before adding files. Directory
placement drives imports: hosts, system modules, and packages are auto-imported,
and the hostname is derived from the directory name. Settings that belong to
this user's configuration use the `my.*` option namespace, not raw NixOS or
Home-Manager options.

Do not read these: `assets/*.png` and `hosts/augustROG/edid-*.bin` are binary,
and `hosts/augustROG/facter.json` is machine-generated and large. Refer to them
by path only.

## Constraints Worth Knowing Up Front

- One user (`adeer`), one host (`augustROG`), `x86_64-linux` only.
- Hosts are auto-imported from `hosts/<name>/default.nix`; the hostname is
  derived from the directory name. Never set `networking.hostName` manually.
- `nixosModules/` and `homeModules/` are auto-imported; new files need no
  registration. Likewise `packages/<name>.nix`.
- Unfree packages are allowed centrally in `flakeModules/nixpkgs.nix`. A module
  needing an unfree package must add it to that list.
- `stateVersion` is pinned deliberately. Do not bump it without being asked.
