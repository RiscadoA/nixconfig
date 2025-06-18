# modules/home/desktop/apps/mako.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# mako home configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.apps.mako;
in
{
  options.modules.desktop.apps.mako.enable = mkEnableOption "mako";

  config = mkIf cfg.enable {
    services.mako = {
      enable = true;
      settings = {};
    };
  };
}
