# modules/home/xmobar.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# xmobar home configuration.

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    haskellPackages.xmobar
  ];
  home.file = {
    ".xmonad/xmobar.hs".source = ../../haskell/xmobar.hs;
  };
}
