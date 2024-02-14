# modules/home/shell/gdb.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# GDB home configuration.

{ pkgs, lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.shell.gdb;
in
{
  options.modules.shell.gdb.enable = mkEnableOption "gdb";

  config = mkIf cfg.enable {
    home = {
      packages = [
        pkgs.gdb
      ];

      file.".gdbinit".text = ''
        set auto-load safe-path /nix/store
      '';
    };
  };
}
