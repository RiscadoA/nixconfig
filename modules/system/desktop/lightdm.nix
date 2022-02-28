# modules/system/desktop/lightdm.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# LightDM system configuration.

{ lib, config, user, ... }:

let
  inherit (lib) mkEnableOption mkOption types mkIf mkMerge;
  cfg = config.modules.desktop.lightdm;
in
{
  options.modules.desktop.lightdm = {
    enable = mkEnableOption "lightdm";
    auto = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    services.xserver.displayManager = if cfg.auto then {
      autoLogin = {
        enable = true;
        inherit user;
      };
      lightdm = {
        enable = true;
        extraConfig = ''
          set logind-check-graphical=true
        '';
        greeter.enable = false;
      };
    } else {
      lightdm = {
        enable = true;
        extraConfig = ''
          set logind-check-graphical=true
        '';
        greeters.mini = {
          enable = true;
          inherit user;
        };
      };
    };
  };
}
