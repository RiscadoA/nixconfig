# modules/home/desktop/apps/kitty.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# kitty home configuration.

{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.desktop.apps.kitty;
in
{
  options.modules.desktop.apps.kitty = {
    enable = mkEnableOption "kitty";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      themeFile = "tokyo_night_night";
      settings = {
        background_opacity = 0.9;
      };
    };
  };
}
