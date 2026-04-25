# modules/home/desktop/apps/fuzzel.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# fuzzel home configuration. Tokyo Night themed launcher.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.apps.fuzzel;
in
{
  options.modules.desktop.apps.fuzzel.enable = mkEnableOption "fuzzel";

  config = mkIf cfg.enable {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          font = "Noto Sans Mono:size=11";
          prompt = "Search... ";
          width = 40;
          lines = 8;
          icon-theme = "Papirus-Dark";
          icons-enabled = true;
          fuzzy = true;
          terminal = "${pkgs.kitty}/bin/kitty";
        };
        colors = {
          background = "1a1b26ff";
          text = "cfc9c2ff";
          match = "7aa2f7ff";
          selection = "1f2335ff";
          selection-text = "7aa2f7ff";
          selection-match = "7dcfffff";
          border = "7aa2f7ff";
        };
        border = {
          width = 2;
          radius = 12;
        };
      };
    };
  };
}
