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

  config = mkIf cfg.enable (mkMerge [
    {
      services.xserver.displayManager = {
        lightdm = {
          enable = true;
          extraConfig = ''
            set logind-check-graphical=true
          '';
        };
        
        defaultSession = "my-session";
        session = [
          {
            name = "my-session";
            manage = "desktop";
            start = ''exec $HOME/.xsession'';
          }
        ];
      };
    }
    {
      services.xserver.displayManager =
        if cfg.auto
        then {
          lightdm.greeter.enable = false;
          autoLogin = {
            enable = true;
            inherit user;
          };
        }
        else {
          lightdm.greeters.mini = {
            enable = true;
            inherit user;
          };
        };
    }
  ]);
}
