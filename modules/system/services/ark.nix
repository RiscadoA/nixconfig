# modules/system/services/ark.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# ARK server system configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.services.ark;
in
{
  options.modules.services.ark = {
    enable = mkEnableOption "ark";
    sessionName = mkOption {
      default = "LLRA";
      type = types.string;
    };
    queryPort = mkOption {
      default = 31100;
      type = types.int;
    };
    rconPort = mkOption {
      default = 31101;
      type = types.int;
    };
    port = mkOption {
      default = 31102;
      type = types.int;
    };
  };

  config = mkIf cfg.enable {
    users.users.ark = {
      isNormalUser = true;
      createHome = true;
      home = "/srv/ark";
    };

    systemd.services."ark_server" = {
      description = "ARK server";
      wants = [ "network-online.target" ];
      after = [ "syslog.target" "network.target" "nss-lookup.target" "network-online.target" ];
      serviceConfig = {
        ExecStartPre = "${pkgs.steamcmd}/bin/steamcmd +login anonymous +force_install_dir /srv/ark/server +app_update 376030 +quit";
        ExecStart = "${pkgs.steam-run}/bin/steam-run /srv/ark/server/ShooterGame/Binaries/Linux/ShooterGameServer TheIsland?listen?sessionName=${cfg.sessionName}?QueryPort=${cfg.queryPort}?RCONPort=${cfg.rconPort}?Port=${cfg.port} -server -log";
        LimitNOFILE = 100000;
        ExecReload = "/usr/bin/env kill -s HUP $MAINPID";
        ExecStop = "/usr/bin/env kill -s INT $MAINPID";

        User = "ark";
        Group = "users";  
      };
    };
  };
}
