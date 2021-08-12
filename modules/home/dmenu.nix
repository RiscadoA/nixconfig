# modules/home/dmenu.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# dmenu home configuration.

{ pkgs, ... }:
{
  home.packages = with pkgs; [ dmenu ];
}
