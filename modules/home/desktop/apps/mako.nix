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
        max-visible = 3;
        sort = "-time";
        layer = "overlay";
        anchor = "top-right";
        font = "Noto Sans Mono 10";
        background-color = "#1a1b26";
        text-color = "#cfc9c2";
        border-color = "#414868";
        border-size = 2;
        border-radius = 12;
        padding = "12,16";
        margin = "8,7,0,0";
        width = 320;
        height = 110;
        icons = true;
        max-icon-size = 48;
        default-timeout = 5000;
        group-by = "summary";

        "urgency=low" = {
          border-color = "#414868";
        };
        "urgency=normal" = {
          border-color = "#7aa2f7";
        };
        "urgency=critical" = {
          border-color = "#cc241d";
          default-timeout = 0;
        };
      };
    };
  };
}
