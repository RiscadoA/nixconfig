---
name: pi-configuration
description: "Configure Pi declaratively through the NixOS home-manager module at /home/riscadoa/nixos/modules/home/desktop/apps/pi.nix. Use this whenever changing pi's configuration: scoped/enabled models, default model or provider, thinking level, theme, compaction, extensions, or skills. Pi cannot persist runtime changes (e.g. saving scoped models with /scoped-models) because ~/.pi/agent/settings.json is a read-only Nix store symlink, and that is intentional."
version: 1.0.0
platforms: [macos, linux]
---

# Pi configuration is managed through NixOS

The user manages pi declaratively via the NixOS home-manager module:

- NixOS config root: `/home/riscadoa/nixos`
- Module: `/home/riscadoa/nixos/modules/home/desktop/apps/pi.nix`
- Option: `modules.desktop.apps.pi.settings` (JSON, mirrors pi's `~/.pi/agent/settings.json`)
- Skill/extension directories: `/home/riscadoa/nixos/config/pi/skills/`, `/home/riscadoa/nixos/config/nono/` (referenced via `configDir`)

## Why runtime changes are not durable (and that is the point)

`~/.pi/agent/settings.json` is declared with `home.file` in the module, which makes it a **read-only symlink into the Nix store**:

1. The Nix config renders the JSON at build time; home-manager symlinks `~/.pi/agent/settings.json` to that store path.
2. The store is immutable, so pi **cannot write to it at all**. Runtime attempts (e.g. Ctrl+S "save to settings" in `/scoped-models`, `/model`, `/settings`) fail with EROFS, and pi's settings manager swallows the error and shows a success message anyway.

This is deliberate: the Nix config is the single source of truth, and pi must not be able to persist config changes behind the user's back. Pi's settings file always reflects `modules.desktop.apps.pi.settings` exactly.

Do not "fix" this by changing pi's settings at runtime and expecting them to stick, and do not change the file to be writable (e.g. via `home.activation` copies) unless the user explicitly asks.

## What to do instead

To change pi configuration:

1. Edit `/home/riscadoa/nixos/modules/home/desktop/apps/pi.nix` and set the desired keys under `modules.desktop.apps.pi.settings` (e.g. `enabledModels`, `defaultModel`, `defaultProvider`, `defaultThinkingLevel`, `theme`).
2. If adding new files under `/home/riscadoa/nixos/config/` (e.g. a new skill dir), `git add` them first: the flake source copy only includes git-tracked files, so untracked files silently end up missing from the built settings.
3. Rebuild with `home-manager switch` (or `nixos-rebuild switch --flake .#<host>`).
4. Restart pi.

## Examples

Scoped models (Ctrl+P cycling) limited to DeepSeek v4 flash and pro:

```nix
settings = {
  enabledModels = [
    "deepseek/deepseek-v4-flash"
    "deepseek/deepseek-v4-pro"
  ];
};
```

Set a default model:

```nix
settings = {
  defaultProvider = "deepseek";
  defaultModel = "deepseek-v4-pro";
};
```

## History

`home.file` (read-only store symlink) is the intended approach and was kept. An intermediate version used a `home.activation` script to copy the generated JSON to a real writable file, but that was reverted: the user wants pi's config read-only so changes go through NixOS.
