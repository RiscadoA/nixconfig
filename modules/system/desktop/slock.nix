# modules/system/desktop/slock.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Slock system configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.desktop.slock;
in
{
  options.modules.desktop.slock = {
    enable = mkEnableOption "slock";
    autolock = {
      enable = mkEnableOption "autolock";
      time = mkOption {
        default = 15;
        type = types.int;
      };
    };
  };

  config = mkIf cfg.enable {
    programs.slock.enable = true;
    services.xserver.xautolock = mkIf cfg.autolock.enable {
      enable = true;
      time = cfg.autolock.time;
      locker = "${pkgs.slock}/bin/slock";
    };
  };
}
