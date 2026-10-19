# modules/home/desktop/apps/codex.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# codex home configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.apps.codex;
in
{
  options.modules.desktop.apps.codex.enable = mkEnableOption "codex";

  config = mkIf cfg.enable {
    programs.codex = {
      enable = true;
      package = pkgs.unstable.codex;
    };
  };
}
