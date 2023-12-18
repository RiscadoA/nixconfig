# modules/home/shell/taskwarrior.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Taskwarrior home configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.shell.taskwarrior;
in
{
  options.modules.shell.taskwarrior.enable = mkEnableOption "taskwarrior";

  config = mkIf cfg.enable {
    programs.taskwarrior.enable = true;
  };
}
