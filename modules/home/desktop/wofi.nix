# modules/home/desktop/wofi.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# wofi home configuration.

{ lib, config, pkgs, configDir, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.wofi;
in
{
  options.modules.desktop.wofi.enable = mkEnableOption "wofi";

  config = mkIf cfg.enable {
    programs.wofi = {
      enable = true;
    };
  };
}
