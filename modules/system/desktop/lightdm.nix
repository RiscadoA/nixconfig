# modules/system/desktop/lightdm.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# LightDM system configuration.

{ lib, config, ... }:

let
  inherit (builtins) length head;
  inherit (lib) mkEnableOption mkOption types mkIf mkMerge;
  cfg = config.modules.desktop.lightdm;
in
{
  options.modules.desktop.lightdm = {
    enable = mkEnableOption "lightdm";
    users = mkOption {
      default = [ ];
      type = types.listOf types.str;
    };
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

        session = [
          {
            name = "default";
            manage = "desktop";
            start = ''exec $HOME/.xsession'';
          }
        ];
      };

      services.displayManager.defaultSession = "default";

      security.pam.services.lightdm.text = ''
        auth sufficient pam_succeed_if.so user ingroup nopasswdlogin
      '';
    }
    {
      services.xserver.displayManager =
        if cfg.auto
        then {
          lightdm.greeter.enable = false;
        }
        else {
          lightdm.greeters.gtk = {
            enable = true;
            indicators = [ ];
          };
        };

      services.displayManager =
        if cfg.auto
        then {
          autoLogin = {
            enable = true;
            user = head cfg.users;
          };
        }
        else { };
    }
  ]);
}
