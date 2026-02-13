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

  services.dnsmasq = {
    enable = true;
    settings = {
      listen-address = "0.0.0.0";
      bind-interfaces = true;
      no-resolv = true;
      server = [ "1.1.1.1" ];
      address = [
        "/firefly.home.riscadoa.com/100.126.246.110"
      ];
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
    virtualHost = "firefly.home.riscadoa.com";
    settings = {
      APP_KEY_FILE = "/var/lib/firefly-iii/app-key";
      APP_URL = "http://localhost";
	    DB_CONNECTION = "pgsql";
      DB_DATABASE = "firefly-iii";
      DB_USERNAME = "firefly-iii";
      TZ = "Europe/Lisbon";
      TRUSTED_PROXIES = "**";
      AUTHENTICATION_GUARD = "remote_user_guard";
      AUTHENTICATION_GUARD_HEADER = "HTTP_X_EMAIL";
    };
  };

  services.nginx.virtualHosts."firefly.home.riscadoa.com".locations."~ \\.php$".extraConfig = ''
    fastcgi_param HTTP_X_EMAIL "firefly@riscadoa.com";
  '';

  services.nginx.virtualHosts."actual" = {
    enableACME = false;
    forceSSL = false;
    serverName = "actual.home.riscadoa.com";
    locations."/" = {
      proxyPass = "http://localhost:3000";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';
    };
  };

  services.cloudflared = {
    enable = true;
    tunnels."248c8d02-aa20-4b78-bd43-ff97dc766b78" = {
      credentialsFile = "/home/riscadoa/.cloudflared/248c8d02-aa20-4b78-bd43-ff97dc766b78.json";
      default = "http_status:404";
    };
  };
}

