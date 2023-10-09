# hosts/alpha/users/riscadoa.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Home configuration for user 'riscadoa'.

{ pkgs, ... }:
{
  user = {
    isNormalUser = true;
    createHome = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "video" "libvirtd" "docker" ];
  };
}
