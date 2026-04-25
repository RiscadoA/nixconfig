# NixOS Configuration Notes

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
