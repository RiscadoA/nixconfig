# modules/home/desktop/services/flameshot.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# flameshot home configuration.

{ lib, pkgs, config, configDir, ... }:
let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.modules.desktop.services.flameshot;

  flameshot = pkgs.flameshot.overrideAttrs (oldAttrs: {
    postInstall = (oldAttrs.postInstall or "") + ''
      wrapProgram $out/bin/flameshot --set QT_SCALE_FACTOR '${toString cfg.scaleFactor}'  
    '';
  });
in
{
  options.modules.desktop.services.flameshot = {
    enable = mkEnableOption "flameshot";
    scaleFactor = mkOption {
      type = lib.types.float;
      default = 1.0;
      description = "Scale factor for the flameshot UI.";
    };
  };

  config = mkIf cfg.enable {
    services.flameshot = {
      enable = true;
      package = flameshot;
      settings = {
        "General" = {
          useGrimAdapter = true;
          disabledGrimWarning = true;
        };
      };
    };
  };
}
