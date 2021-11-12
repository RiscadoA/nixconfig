# modules/home/xmobar-laptop.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# xmobar laptop home configuration.

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    haskellPackages.xmobar
  ];
  home.file = {
    ".xmonad/xmobar.hs".source = ../../haskell/xmobar-laptop.hs;
  };
}
