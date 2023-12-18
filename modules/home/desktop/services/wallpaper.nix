# modules/home/desktop/services/wallpaper.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# wallpaper home configuration.

{ lib, config, configDir, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.services.wallpaper;
in
{
  options.modules.desktop.services.wallpaper.enable = mkEnableOption "wallpaper";

  config = mkIf cfg.enable {
    services.random-background = {
      enable = true;
      imageDirectory = "${configDir}/wallpapers";
    };
  };
}
