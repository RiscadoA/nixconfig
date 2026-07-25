# modules/system/desktop/niri.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Niri system configuration.

{ lib, pkgs, config, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.niri;
in
{
  options.modules.desktop.niri.enable = mkEnableOption "niri";

  config = mkIf cfg.enable {
    programs.niri = {
      enable = true;
      package = pkgs.niri;
    };

    environment.systemPackages = with pkgs; [ 
      xwayland-satellite
    ];

    security.pam.services.hyprlock = {};

    systemd.user.services.niri-greeter-wait = {
      description = "Wait for greeter session cleanup before niri starts";
      wantedBy = [ "niri.service" ];
      before = [ "niri.service" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c 'for i in $(seq 1 100); do ${pkgs.procps}/bin/pgrep -u greeter >/dev/null 2>&1 || break; sleep 0.1; done'";
      };
    };
  };
}
