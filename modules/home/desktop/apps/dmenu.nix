# modules/home/desktop/apps/dmenu.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# dmenu home configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.apps.dmenu;
in
{
  options.modules.desktop.apps.dmenu.enable = mkEnableOption "dmenu";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.dmenu ];
  };
}
