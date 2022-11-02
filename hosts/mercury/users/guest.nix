# hosts/mercury/users/guest.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Home configuration for user 'guest'.

{ pkgs, ... }:
{
  user = {
    isNormalUser = true;
    createHome = true;
    shell = pkgs.zsh;
    extraGroups = [ "nopasswdlogin" "libvirtd" ];
  };

  #services.xserver.windowManager.openbox.enable = true;
}
