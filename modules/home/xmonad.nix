# modules/home/xmonad.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# xmonad home configuration.

{ ... }:
{
  xsession.enable = true;
  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    config = ../../haskell/xmonad.hs;
  };
}
