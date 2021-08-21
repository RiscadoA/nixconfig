# modules/system/slock.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Slock system configuration.

{ pkgs, ... }:
{
  programs.slock.enable = true;
  services.xserver.xautolock = {
    enable = true;
    time = 15;
    locker = "${pkgs.slock}/bin/slock";
  };
}
