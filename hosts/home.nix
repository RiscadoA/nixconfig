# hosts/home.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
# 
# Default/common configuration for all host homes.

{ ... }:
{
  home = {
    keyboard = null;
    stateVersion = "21.11";

    shellAliases = {
      "rebuild" = "sudo nixos-rebuild switch --flake $HOME/nixos";
    };
  };
}
