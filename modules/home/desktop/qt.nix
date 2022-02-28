# modules/home/desktop/qt.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Qt home configuration.

{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.qt;
in
{
  options.modules.desktop.qt.enable = mkEnableOption "qt";

  config = mkIf cfg.enable {
    qt = {
      enable = true;
      platformTheme = "gtk";
    };
  };
}
