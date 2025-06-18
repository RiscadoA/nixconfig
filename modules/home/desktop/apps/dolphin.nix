# modules/home/desktop/apps/dolphin.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Dolphin home configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.apps.dolphin;
in
{
  options.modules.desktop.apps.dolphin.enable = mkEnableOption "dolphin";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
        kdePackages.dolphin
        kdePackages.qtsvg # Needed for dolphin to be able to show SVG icons
        kdePackages.kdegraphics-thumbnailers # Needed for dolphin to be able to show RAW/NEF etc image previews
        kdePackages.ark # For archive compression/decompression
        kdePackages.ffmpegthumbs # To show video previews
    ];

    home.file.".config/dolphinrc".text = ''
      [General]
      Version=202
      ViewPropsTimestamp=2024,9,13,9,35,26.475

      [IconsMode]
      PreviewSize=208

      [KFileDialog Settings]
      Places Icons Auto-resize=false
      Places Icons Static Size=22

      [MainWindow]
      MenuBar=Disabled

      [UiSettings]
      ColorScheme=Kvantum-Tokyo-Night
    '';
  };
}
