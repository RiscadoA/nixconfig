# modules/home/desktop/hyprsunset.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# hyprsunset home configuration.

{ lib, config, pkgs, configDir, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.hyprsunset;
in
{
  options.modules.desktop.hyprsunset.enable = mkEnableOption "hyprsunset";

  config = mkIf cfg.enable {
    services.hyprsunset = {
      enable = true;
      package = pkgs.hyprsunset;
      transitions = {
        sunrise = {
          calendar = "*-*-* 06:00:00";
          requests = [
            [ "temperature" "6500" ]
          ];
        };
        sunset = {
          calendar = "*-*-* 20:00:00";
          requests = [
            [ "temperature" "3500" ]
          ];
        };
      };
    };
  };
}
