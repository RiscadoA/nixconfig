# modules/system/desktop/niri.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Niri system configuration.

{ lib, pkgs, config, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.niri;
in
{
  options.modules.desktop.niri.enable = mkEnableOption "niri";

  config = mkIf cfg.enable {
    programs.niri = {
      enable = true;
      package = pkgs.unstable.niri;
    };

    security.pam.services.hyprlock = {};
  };
}
