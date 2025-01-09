# modules/home/desktop/games/minecraft.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# minecraft home configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.desktop.games.minecraft;
in
{
  options.modules.desktop.games.minecraft.enable = mkEnableOption "minecraft";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.prismlauncher ];
  };
}
