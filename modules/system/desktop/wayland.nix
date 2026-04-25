# modules/system/desktop/wayland.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Generic Wayland system configuration.

{ lib, pkgs, config, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.wayland;
in
{
  options.modules.desktop.wayland.enable = mkEnableOption "wayland";

  config = mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.xdg-desktop-portal
        pkgs.xdg-desktop-portal-wlr
      ];
    };
  };
}
