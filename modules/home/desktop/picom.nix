# modules/home/desktop/picom.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Picom home configuration.

{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.picom;
in
{
  options.modules.desktop.picom.enable = mkEnableOption "picom";

  config = mkIf cfg.enable {
    services.picom = {
      enable = true;
      blur = true;
      fade = false;
      inactiveDim = "0.2";
      vSync = true;
    };
  };
}
