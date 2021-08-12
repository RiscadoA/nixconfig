# modules/system/xmonad.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# xmonad system configuration.

{ ... }:
{
  services.xserver = {
    windowManager.xmonad = {
      enable = true;
      config = ../../haskell/xmonad.hs;
      extraPackages = hpkgs: [
        hpkgs.xmonad-contrib
        hpkgs.xmonad
      ];
    };

    displayManager.defaultSession = "none+xmonad";
  };
}
