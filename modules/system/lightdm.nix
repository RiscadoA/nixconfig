# modules/system/lightdm.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# LightDM system configuration.

{ ... }:
{
  services.xserver.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "riscadoa";
    lightdm.enable = true;
    lightdm.greeter.enable = false;
    lightdm.extraConfig = ''
      set logind-check-graphical=true
    '';
  };
}
