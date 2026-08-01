# NixOS Configuration Notes

## Version Control

- **Use `jj` for all version control operations** (status, log, diff, commit/describe, push, pull). Do not run `git` commands.
- This checkout is a **pure jj repo** (no git colocation): the git repository is hidden inside `.jj/`, so `git` commands fail with `fatal: not a git repository` by design. That is expected, not an error.
- The remote is a git remote on GitHub and works through `jj git push` / `jj git pull` (or `jj git fetch`).
- Only fall back to `git` if `jj` is not available at all (e.g. on a machine where jj is not installed).

## Module System

- **Auto-discovery**: `flake.nix` recursively imports every `.nix` file under `modules/system/` and `modules/home/`. No manual imports needed when adding new files or directories.
- **Option namespace**: Home modules use `modules.*`, system modules also use `modules.*`. Host configs enable them with `modules.<path>.enable = true`.
- **Hosts**: Defined in `hosts/<hostname>/`. Each host has `system.nix`, `home.nix`, `hardware.nix`, and a `users/` directory with per-user home configs.
- **Shared configs**: `hosts/system.nix` and `hosts/home.nix` are imported for all hosts.

## Key Conventions

- Use `pkgs.unstable.*` for packages that should track nixpkgs-unstable.
- `configDir` points to `./config` (flake root).
- `secrets` points to `./secrets`.
- Waybar config lives in `modules/home/desktop/waybar.nix` and is tightly coupled to Hyprland for now.
