# modules/home/desktop/apps/alacritty.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# alacritty home configuration.

{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.apps.alacritty;
in
{
  options.modules.desktop.apps.alacritty.enable = mkEnableOption "alacritty";

  config = mkIf cfg.enable { 
    programs.alacritty = {
      enable = true;
      settings = {
        font.size = 9.0;
        colors = {
          primary = {
            background = "#1d2021";
            foreground = "#ebdbb2";
            bright_foreground = "#fbf1c7";
            dim_foreground = "#a89984";
          };
          cursor = {
            text = "CellBackground";
            cursor = "CellForeground";
          };
          vi_mode_cursor = {
            text = "CellBackground";
            cursor = "CellForeground";
          };
          selection = {
            text = "CellBackground";
            cursor = "CellForeground";
          };
          bright = {
            black   = "#928374";
            red     = "#fb4934";
            green   = "#b8bb26";
            yellow  = "#fabd2f";
            blue    = "#83a598";
            magenta = "#d3869b";
            cyan    = "#8ec07c";
            white   = "#ebdbb2";
          };
          normal = {
            black   = "#1d2021";
            red     = "#cc241d";
            green   = "#98971a";
            yellow  = "#d79921";
            blue    = "#458588";
            magenta = "#b16286";
            cyan    = "#689d6a";
            white   = "#a89984";
          };
          dim = {
            black   = "#32302f";
            red     = "#9d0006";
            green   = "#79740e";
            yellow  = "#b57614";
            blue    = "#076678";
            magenta = "#8f3f71";
            cyan    = "#427b58";
            white   = "#928374";
          };
        };
      };
    };
  };
}
