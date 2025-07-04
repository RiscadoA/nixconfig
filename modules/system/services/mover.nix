# modules/system/services/mover.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Mover server system configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkMerge mkIf;
  cfg = config.modules.services.mover;
in
{
  options.modules.services.mover = {
    enable = mkEnableOption "mover";
    hostName = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    users.users.mover = {
      isNormalUser = true;
      createHome = true;
      home = "/srv/mover";
    };

    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_13;
      ensureDatabases = [ "mover" ];
      ensureUsers = [
        {
          name = "mover";
          ensureDBOwnership = true;
        }
      ];
    };

    systemd.services."mover" = {
      description = "Mover";
      requires = [ "network-online.target" ];
      after = [ "syslog.target" "network.target" "nss-lookup.target" "network-online.target" ];
      serviceConfig = {
        WorkingDirectory = "/srv/mover/Mover/Server";
        ExecStartPre = [
          "${pkgs.yarn}/bin/yarn install"
          "${pkgs.yarn}/bin/yarn build"
        ];
        ExecStart = "${pkgs.yarn}/bin/yarn prod";
        Restart = "always";

        User = "mover";
        Group = "users";
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts."${cfg.hostName}" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:3000";
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "acme@riscadoa.com";
    };
  };
}
