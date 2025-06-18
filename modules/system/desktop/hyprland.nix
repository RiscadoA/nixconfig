# modules/system/desktop/hyprland.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Hyprland system configuration.

{ lib, pkgs, config, ... }:

let
  inherit (builtins) length head;
  inherit (lib) mkEnableOption mkOption types mkIf mkMerge;
  cfg = config.modules.desktop.hyprland;
in
{
  options.modules.desktop.hyprland.enable = mkEnableOption "hyprland";

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
      withUWSM = true;
    };

    security.pam.services.hyprlock = {};

    xdg.portal = {
        enable = true;
        xdgOpenUsePortal= true;
        config = {
            hyprland.default = ["hyprland"];
        };
        extraPortals = [
            pkgs.xdg-desktop-portal
            pkgs.xdg-desktop-portal-wlr
        ];
    };
  };
}
