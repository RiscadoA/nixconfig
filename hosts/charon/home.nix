# hosts/charon/home.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Home configuration shared by every user of charon (headless server; cli profile).
{ pkgs, ... }:
{
  profiles.cli.enable = true;

  # Host-specific packages.
  home.packages = with pkgs; [
    busybox
  ];
}