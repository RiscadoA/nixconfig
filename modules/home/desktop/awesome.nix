# modules/home/desktop/awesome.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# awesome home configuration.

{ lib, config, pkgs, configDir, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.awesome;
in
{
  options.modules.desktop.awesome.enable = mkEnableOption "awesome";

  config = mkIf cfg.enable {
    xsession = {
      enable = true;
      windowManager.awesome = {
        enable = true;
        luaModules = with pkgs.luaPackages; [
          # TODO
        ];
      };
    };
  };
}
