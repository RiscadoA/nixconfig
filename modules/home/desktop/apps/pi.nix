# modules/home/desktop/apps/pi.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Pi (pi.dev) home configuration.

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
in
{
  options.modules.desktop.apps.pi = {
    enable = mkEnableOption "pi";

    settings = mkOption {
      inherit (jsonFormat) type;
      default = {
        defaultThinkingLevel = "medium";
        theme = "dark";
        compaction = {
          enabled = true;
          reserveTokens = 16384;
          keepRecentTokens = 20000;
        };
      };
      example = {
        defaultProvider = "anthropic";
        defaultModel = "claude-sonnet-4-20250514";
        defaultThinkingLevel = "medium";
        theme = "dark";
        packages = [ "pi-skills" ];
      };
      description = ''
        Global settings written to {file}`~/.pi/agent/settings.json`.
        See <https://pi.dev/docs/latest> for the documentation.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.unstable.pi-coding-agent ];

    home.file.".pi/agent/settings.json".source =
      jsonFormat.generate "pi-settings.json" (cfg.settings // nonoSettings);
  };
}
