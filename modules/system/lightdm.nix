# modules/system/lightdm.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# LightDM system configuration.

{ ... }:
{
  services.xserver.displayManager = {
    lightdm.enable = true;
    lightdm.greeters.mini = {
      enable = true;
      user = "riscadoa";
    };
    lightdm.extraConfig = ''
      set logind-check-graphical=true
    '';
  };
}
