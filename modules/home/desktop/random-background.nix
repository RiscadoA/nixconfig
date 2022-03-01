# modules/home/desktop/random-background.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# random-background home configuration.

{ lib, config, configDir, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.random-background;
in
{
  options.modules.desktop.random-background.enable = mkEnableOption "random-background";

  config = mkIf cfg.enable {
    services.random-background = {
      enable = true;
      imageDirectory = "${configDir}/wallpapers";
    };
  };
}