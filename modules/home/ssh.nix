# modules/home/ssh.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Ssh home configuration.

{ ... }:
{
  programs.ssh.enable = true;
  programs.ssh.matchBlocks = {
    theta = {
      hostname = "theta.riscadoa.com";
      user = "riscadoa";
    };
  };
}
