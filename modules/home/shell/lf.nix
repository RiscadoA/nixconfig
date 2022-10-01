# modules/home/shell/lf.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# lf home configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.shell.lf;
in {
  options.modules.shell.lf.enable = mkEnableOption "lf";

  config = mkIf cfg.enable {
    programs.lf.enable = true;
  };
}
