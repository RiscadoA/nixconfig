# modules/system/hardware/qmk.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# qmk configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.hardware.qmk;
in {
  options.modules.hardware.qmk.enable = mkEnableOption "qmk";

  config = mkIf cfg.enable {
    hardware.keyboard.qmk.enable = true;
  };
}
