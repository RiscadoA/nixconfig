# modules/system/hardware/backlight.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# backlight configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.hardware.backlight;
in {
  options.modules.hardware.backlight.enable = mkEnableOption "backlight";

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.light ];
  };
}
