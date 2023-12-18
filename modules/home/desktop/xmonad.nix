# modules/home/desktop/xmonad.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# xmonad home configuration.

{ lib, config, pkgs, configDir, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.xmonad;
in
{
  options.modules.desktop.xmonad.enable = mkEnableOption "xmonad";

  config = mkIf cfg.enable {
    xsession = {
      enable = true;
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = "${configDir}/xmonad.hs";
      };
    };

    home.packages = [ pkgs.playerctl ];
  };
}
