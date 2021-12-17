# modules/system/ark.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# ARK server system configuration.

{ options, config, pkgs, ... }: with pkgs.lib; {
  options.services.arkServer = {
    enable = mkEnableOption "ark";
  };

  config = {
    systemd.services.ark_server = {
      description = "ARK server";
      wants = [ "network-online.target" ];
      after = [ "syslog.target" "network.target" "nss-lookup.target" "network-online.target" ];
      serviceConfig = {
        ExecStartPre = "${pkgs.steamcmd}/bin/steamcmd +login anonymous +force_install_dir /srv/ark/server +app_update 376030 +quit";
        ExecStart = "${pkgs.steam-run}/bin/steam-run /srv/ark/server/ShooterGame/Binaries/Linux/ShooterGameServer TheIsland?listen?sessionName=LLRA?QueryPort=31100?RCONPort=31101?Port=31102 -server -log";
        LimitNOFILE = 100000;
        ExecReload = "/usr/bin/env kill -s HUP $MAINPID";
        ExecStop = "/usr/bin/env kill -s INT $MAINPID";

        User = "ark";
        Group = "users";  
      };
    };
  };
}
