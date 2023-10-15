# modules/system/services/zomboid.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Project Zomboid server system configuration.

{ lib, config, pkgs, ... }:
let
  inherit (builtins) toString;
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.services.zomboid;
in
{
  options.modules.services.zomboid = {
    enable = mkEnableOption "zomboid";
  };

  config = mkIf cfg.enable {
    users.users.zomboid = {
      isNormalUser = true;
      createHome = true;
      home = "/srv/zomboid";
    };

    systemd = {
      services."zomboid" = {
        description = "Project Zomboid server";
        wants = [ "network-online.target" ];
        after = [ "syslog.target" "network.target" "nss-lookup.target" "network-online.target" ];
        serviceConfig = {
          PrivateTmp = true;
          ExecStartPre = "${pkgs.steamcmd}/bin/steamcmd +force_install_dir /srv/zomboid/server +login anonymous +app_update 380870 +quit";
          ExecStart = "${pkgs.steam-run}/bin/steam-run /srv/zomboid/server/start-server.sh < /srv/zomboid/server/zomboid.control";
          ExecStop = "${pkgs.bash}/bin/bash -c \"echo save > /srv/zomboid/server/zomboid.control; sleep 15; echo quit > /srv/zomboid/server/zomboid.control\"";
          KillSignal = "SIGCONT";
          User = "zomboid";
          Group = "users";  
        };
      };

      sockets."zomboid" = {
        bindsTo = [ "zomboid.service" ];
        socketConfig = {
          ListenFIFO = "/srv/zomboid/server/zomboid.control";
          FileDescriptorName = "control";
          RemoveOnStop = true;
          SocketMode = "0660";
          SocketUser = "zomboid";
        };
      };
    };

    networking.firewall.allowedUDPPorts = [ 16261 16262 ];
  };
}
