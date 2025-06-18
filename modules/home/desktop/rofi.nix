# modules/home/desktop/rofi.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# rofi home configuration.

{ lib, config, pkgs, configDir, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.rofi;
in
{
  options.modules.desktop.rofi.enable = mkEnableOption "rofi";

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      location = "center";
      extraConfig = {
        case-sensitive = false;
      };
      theme = "${configDir}/rofi.rasi";
    };
  };
}
