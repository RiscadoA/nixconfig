# modules/home/gnupg.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# GnuPG home configuration.

{ config, ... }:
{
  services.gpg-agent.enable = true;
  services.gpg-agent.enableSshSupport = true;
  services.gpg-agent.sshKeys = [ "9FE5C9E282E9ED1710A3FCBEA5DC9B43099FCE41" ];
  programs.gpg.enable = true;
  programs.gpg.homedir = "${config.xdg.dataHome}/gnupg";
}
