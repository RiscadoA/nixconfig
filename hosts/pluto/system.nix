{ config, pkgs, options, inputs, lib, configDir, ... }:
{
  # Modules configuration.
  modules = {
    services = {
      tailscale.enable = true;
      cubos-discord-bot.enable = true;
    };
  };

  boot.tmp.cleanOnBoot = true;

  zramSwap.enable = true;

  networking.domain = "";

  services.openssh.enable = true;
  services.syncthing.enable = true;

  services.tsnsrv = {
    enable = true;
    defaults.authKeyPath = "/home/riscadoa/.tailscale-auth-key";
    defaults.urlParts.host = "127.0.0.1";
    services = {
      "actual".urlParts.port = 3000;
      "firefly".urlParts.port = 3001;
    };
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_18;
    ensureDatabases = [ "firefly-iii" ];
    ensureUsers = [
      {
        name = "firefly-iii";
        ensureDBOwnership = true;
      }
    ];
  };

  services.actual = {
    package = pkgs.unstable.actual-server;
    enable = true;
    settings = {
      port = 3000;
      loginMethod = "header";
    };
  };

  services.firefly-iii = {
    package = pkgs.unstable.firefly-iii;
    enable = true;
    enableNginx = true;
    settings = {
      APP_KEY_FILE = "/var/lib/firefly-iii/app-key";
      APP_URL = "https://localhost";
	    DB_CONNECTION = "pgsql";
      DB_DATABASE = "firefly-iii";
      DB_USERNAME = "firefly-iii";
      TZ = "Europe/Lisbon";
      TRUSTED_PROXIES = "**";
    };
  };

  services.nginx.virtualHosts.${config.services.firefly-iii.virtualHost}.listen = [ { addr = "*"; port = 3001; } ];

  services.cloudflared = {
    enable = true;
    tunnels."248c8d02-aa20-4b78-bd43-ff97dc766b78" = {
      credentialsFile = "/home/riscadoa/.cloudflared/248c8d02-aa20-4b78-bd43-ff97dc766b78.json";
      default = "http_status:404";
    };
  };
}

