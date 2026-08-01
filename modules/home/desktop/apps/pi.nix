# modules/home/desktop/apps/pi.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Pi (pi.dev) home configuration.
#
# Also provides piusage, an aggregate pi token usage and cost tool, as a
# builtin: it reads pi's session JSONL files under ~/.pi/agent/sessions and
# reports today / this week / this month / last 30 days / all time usage,
# plus a daily breakdown and per-project totals. Data comes from the
# per-message usage records pi writes into each session file.

{ lib, config, pkgs, configDir, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.modules.desktop.apps.pi;
  jsonFormat = pkgs.formats.json { };
  nonoCfg = config.modules.desktop.apps.nono.piProfile or { enable = false; };
  nonoSettings =
    if nonoCfg.enable then
      {
        extensions = [ "${configDir}/nono/nono-sandbox.ts" ];
        skills = [ "${configDir}/nono/nono-sandbox" ];
      }
    else
      { };

  # Settings written to ~/.pi/agent/settings.json: the declarative `settings`
  # option plus always-registered skill/extension paths. Lists are merged (not
  # replaced) so the pi config skill, the nono sandbox skill, and the piusage
  # usage-footer extension coexist.
  effectiveSettings = cfg.settings // {
    skills = (cfg.settings.skills or [ ])
      ++ [ "${configDir}/pi/skills/pi-configuration" ]
      ++ (nonoSettings.skills or [ ]);
    extensions = (cfg.settings.extensions or [ ])
      ++ (nonoSettings.extensions or [ ])
      ++ [ "${configDir}/pi/extensions/usage-footer.ts" ];
  };
in
{
  options.modules.desktop.apps.pi = {
    enable = mkEnableOption "pi";

    settings = mkOption {
      inherit (jsonFormat) type;
      default = {
        defaultThinkingLevel = "medium";
        theme = "dark";
        # Scoped models for Ctrl+P cycling: DeepSeek v4 flash and pro only.
        # Note: provider is opencode-go, not deepseek, in the model catalog.
        enabledModels = [
          "opencode-go/deepseek-v4-flash"
          "opencode-go/deepseek-v4-pro"
        ];
        compaction = {
          enabled = true;
          reserveTokens = 16384;
          keepRecentTokens = 20000;
        };
      };
      example = {
        defaultProvider = "deepseek";
        defaultModel = "deepseek-v4-pro";
        defaultThinkingLevel = "medium";
        theme = "dark";
        enabledModels = [
          "opencode-go/deepseek-v4-flash"
          "opencode-go/deepseek-v4-pro"
        ];
        packages = [ "pi-skills" ];
      };
      description = ''
        Global settings written to {file}`~/.pi/agent/settings.json`.
        See <https://pi.dev/docs/latest> for the documentation.

        Pi is configured declaratively through NixOS: this option is the
        single source of truth and is re-seeded on every `home-manager switch`,
        so runtime changes inside pi (e.g. saving scoped models) are lost.
        Prefer editing this option over pi's in-app settings.
      '';
    };

    keybindings = mkOption {
      inherit (jsonFormat) type;
      default = {
        # By default pi binds ctrl+backspace to "delete session when query is
        # empty", so it does nothing while typing. Rebind it to delete a whole
        # word, matching shell behavior.
        "tui.editor.deleteWordBackward" = [
          "ctrl+w"
          "alt+backspace"
          "ctrl+backspace"
        ];
      };
      example = {
        "tui.editor.deleteWordBackward" = [ "ctrl+w" "alt+backspace" ];
        "tui.editor.cursorWordLeft" = [ "alt+b" ];
      };
      description = ''
        Keybinding overrides written to {file}`~/.pi/agent/keybindings.json`.
        See <https://pi.dev/docs/latest/keybindings> for the full list of
        actions and defaults.

        Same philosophy as `settings`: the Nix config is the single source of
        truth and the file is a read-only store symlink. Pi only ever reads
        this file (on startup and on `/reload`), so the symlink is safe, but
        runtime tweaks to keybindings are not persisted — edit this option
        instead.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.unstable.pi-coding-agent
      # `piusage [days]` - prints aggregate usage across all pi sessions.
      (pkgs.writeScriptBin "piusage" (builtins.readFile "${configDir}/bin/piusage.pl"))
      pkgs.perl
    ];

    # Pi is configured declaratively through NixOS and the settings file is
    # intentionally read-only: pi must not persist runtime changes (e.g.
    # saving scoped models), because the Nix config is the single source of
    # truth. home.file generates a read-only Nix store symlink, so pi's
    # attempts to write fail (EROFS, silently swallowed by pi) and the file
    # always reflects this option.
    home.file.".pi/agent/settings.json".source =
      jsonFormat.generate "pi-settings.json" effectiveSettings;

    # Same single-source-of-truth approach as settings.json. Pi only reads
    # keybindings (startup and /reload), so a read-only symlink is safe.
    home.file.".pi/agent/keybindings.json".source =
      jsonFormat.generate "pi-keybindings.json" cfg.keybindings;
  };
}
