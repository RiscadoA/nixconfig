# modules/home/random-background.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# random-background home configuration.

{ ... }:
{
  services.random-background = {
    enable = true;
    imageDirectory = "${../../wallpapers}";
  };
}
