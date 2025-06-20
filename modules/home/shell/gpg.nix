# modules/home/shell/gpg.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# GnuPG home configuration.

{ pkgs, lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.shell.gpg;
in
{
  options.modules.shell.gpg.enable = mkEnableOption "gpg";

  config = mkIf cfg.enable {
    services.gpg-agent = {
      enable = true;
      # enableSshSupport = true;
      # sshKeys = [ "9FE5C9E282E9ED1710A3FCBEA5DC9B43099FCE41" "" ];
      pinentry.package = pkgs.pinentry-gnome3;
    };
    programs.gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };
  };
}
