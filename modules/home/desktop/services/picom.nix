# modules/home/desktop/services/picom.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# picom home configuration.

{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.services.picom;
in
{
  options.modules.desktop.services.picom.enable = mkEnableOption "picom";

  config = mkIf cfg.enable {
    services.picom = {
      enable = true;
      fade = false;
      vSync = true;
      settings = {
        inactiveDim = "0.2";
        blur.enable = true;
      };
    };
  };
}
