# modules/system/desktop/sddm.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# SDDM system configuration.

{ lib, config, ... }:

let
  inherit (builtins) length head;
  inherit (lib) mkEnableOption mkOption types mkIf mkMerge;
  cfg = config.modules.desktop.sddm;
in
{
  options.modules.desktop.sddm = {
    enable = mkEnableOption "sddm";
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
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
    }
    {
      services.displayManager = mkIf cfg.auto {
        autoLogin = {
          enable = true;
          user = head cfg.users;
        };
      };
    }
  ]);
}
