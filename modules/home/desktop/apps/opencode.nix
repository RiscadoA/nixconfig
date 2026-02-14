# modules/home/desktop/apps/opencode.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# opencode home configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.apps.opencode;
in
{
  options.modules.desktop.apps.opencode.enable = mkEnableOption "opencode";

  config = mkIf cfg.enable {
    programs.opencode = {
      enable = true;
      settings.permission = {
        "*" = "ask";
        "git log *" = "allow";
        "git status" = "allow";
        "timew *" = "allow";
        "grep *" = "allow";
      };
    };
  };
}
