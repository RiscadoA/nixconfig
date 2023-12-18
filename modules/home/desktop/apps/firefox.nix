# modules/home/desktop/apps/firefox.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Firefox home configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.apps.firefox;
in
{
  options.modules.desktop.apps.firefox.enable = mkEnableOption "firefox";

  config = mkIf cfg.enable {
    programs.firefox.enable = true;
    programs.browserpass.enable = true;
  };
}
