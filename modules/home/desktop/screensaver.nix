# modules/home/desktop/screensaver.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# xscreensaver home configuration.

{ lib, config, pkgs, configDir, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.xscreensaver;
in
{
  options.modules.desktop.xscreensaver.enable = mkEnableOption "xscreensaver";

  config = mkIf cfg.enable {
    services.xscreensaver = {
      enable = true;
      settings = {
        mode = "random";
        lock = false;
        timeout = "5";
        cycle = "1";
      };
    };
    home.file.".xscreensaver".source = "${configDir}/xscreensaver";
  };
}
