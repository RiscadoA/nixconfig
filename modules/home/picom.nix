# modules/home/picom.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Picom home configuration.

{ ... }:
{
  services.picom.enable = true;
  services.picom.blur = true;
  services.picom.fade = true;
  services.picom.inactiveDim = "0.2";
  services.picom.vSync = true;
}
