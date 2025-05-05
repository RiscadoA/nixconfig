# modules/home/desktop/games/vintagestory.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# vintagestory home configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  inherit (builtins) fetchurl;
  cfg = config.modules.desktop.games.vintagestory;
in
{
  options.modules.desktop.games.vintagestory.enable = mkEnableOption "vintagestory";

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.unstable.vintagestory
    ];
  };
}
