# modules/home/desktop/apps/spotify.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# spotify home configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.desktop.apps.spotify;
in
{
  options.modules.desktop.apps.spotify.enable = mkEnableOption "spotify";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.spotify ];
  };
}
