# modules/system/hardware/broken-spacebar.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# workaround for having a broken spacebar.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.modules.hardware.broken-spacebar;
in {
  options.modules.hardware.broken-spacebar.enable = mkEnableOption "broken-spacebar";

  config = mkIf cfg.enable {
    services.xserver.displayManager.sessionCommands = ''
      ${pkgs.xorg.xmodmap}/bin/xmodmap -e 'keycode 135=space'
    '';
    # ${pkgs.xorg.xmodmap}/bin/xmodmap -e 'keycode 65='
  };
}
