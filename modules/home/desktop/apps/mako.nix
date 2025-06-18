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
      settings = {
        anchor = "top-right";
        background-color = "#1a1b26";
        text-color = "#cfc9c2";
        width = 350;
        margin = "1,4";
        padding = 10;
        border-size = 2;
        border-color = "#414868";
        border-radius = 4;
        default-timeout = 10000;
        group-by = "summary";
      };
    };
  };
}
