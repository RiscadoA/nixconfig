# modules/home/desktop/apps/thunderbird.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Thunderbird home configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.apps.thunderbird;
in {
  options.modules.desktop.apps.thunderbird.enable = mkEnableOption "thunderbird";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.thunderbird ];
  };
}
