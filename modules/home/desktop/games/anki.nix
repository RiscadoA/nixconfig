# modules/home/desktop/games/anki.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# anki home configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.desktop.games.anki;
in
{
  options.modules.desktop.games.anki.enable = mkEnableOption "anki";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.anki-bin pkgs.mpv ];
  };
}