# modules/home/shell/ssh.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# SSH home configuration.

{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.shell.ssh;
in
{
  options.modules.shell.ssh.enable = mkEnableOption "ssh";

  config = mkIf cfg.enable {
    programs.ssh.enable = true;
  };
}
