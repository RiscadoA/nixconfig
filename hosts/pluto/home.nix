# hosts/pluto/home.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Home configuration shared by every user of pluto (headless server; cli profile).

{ pkgs, ... }:
{
  profiles.cli.enable = true;
}