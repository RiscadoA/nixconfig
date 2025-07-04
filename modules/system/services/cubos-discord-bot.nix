# modules/system/services/cubos-discord-bot.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Cubos discord botsystem configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkMerge mkIf;
  cfg = config.modules.services.cubos-discord-bot;
in
{
  options.modules.services.cubos-discord-bot.enable = mkEnableOption "mover";

  config = mkIf cfg.enable {
    users.users.cubos-discord-bot = {
      isNormalUser = true;
      createHome = true;
      home = "/srv/cubos-discord-bot";
    };

    systemd.services."cubos-discord-bot" = {
      description = "Cubos Discord Bot";
      requires = [ "network-online.target" ];
      after = [ "syslog.target" "network.target" "nss-lookup.target" "network-online.target" ];
      path = [ pkgs.nodejs pkgs.bash ];
      serviceConfig = {
        WorkingDirectory = "/srv/cubos-discord-bot/cubos-discord-bot";
        ExecStartPre = [ "${pkgs.nodejs}/bin/npm install" ];
        ExecStart = "${pkgs.nodejs}/bin/npm start";
        Restart = "always";
        RestartSec = "10";

        User = "cubos-discord-bot";
        Group = "users";
      };
    };
  };
}
