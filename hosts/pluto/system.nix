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

  services.coredns = {
    enable = true;
    config = ''
      . {
        forward . 1.1.1.1 8.8.8.8
        cache
      }
      home.riscadoa.com {
        bind 100.126.246.110
        
        rewrite name importer.firefly.home.riscadoa.com pluto.home.riscadoa.com
        rewrite name firefly.home.riscadoa.com pluto.home.riscadoa.com
        
        hosts {
          100.126.246.110 pluto.home.riscadoa.com
          fallthrough
        }
      }
    '';
  };

  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "acme@riscadoa.com";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      credentialFiles = {
        "CLOUDFLARE_DNS_API_TOKEN_FILE" = "/var/lib/acme/cloudflare-credentials";
      };
      group = "nginx";
    };
  };

  services.openssh.enable = true;
  services.syncthing.enable = true;

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
      APP_URL = "https://firefly.home.riscadoa.com";
	    DB_CONNECTION = "pgsql";
      DB_DATABASE = "firefly-iii";
      DB_USERNAME = "firefly-iii";
      TZ = "Europe/Lisbon";
      TRUSTED_PROXIES = "**";
    };
  };
  security.acme.certs."firefly.home.riscadoa.com".domain = "firefly.home.riscadoa.com";
  services.nginx.virtualHosts."firefly.home.riscadoa.com" = {
    useACMEHost = "firefly.home.riscadoa.com";
    forceSSL = true;
  };

  services.firefly-iii-data-importer = {
    package = pkgs.unstable.firefly-iii-data-importer;
    enable = true;
    enableNginx = true;
    virtualHost = "importer.firefly.home.riscadoa.com";
    user = "firefly-iii";
    settings = {
      APP_URL = "https://importer.firefly.home.riscadoa.com";
      FIREFLY_III_URL = "https://firefly.home.riscadoa.com";
      FIREFLY_III_ACCESS_TOKEN_FILE = "/var/lib/firefly-iii/access-token";
    };
  };
  security.acme.certs."importer.firefly.home.riscadoa.com".domain = "importer.firefly.home.riscadoa.com";
  services.nginx.virtualHosts."importer.firefly.home.riscadoa.com" = {
    useACMEHost = "importer.firefly.home.riscadoa.com";
    forceSSL = true;
  };

  services.cloudflared = {
    enable = true;
    tunnels."248c8d02-aa20-4b78-bd43-ff97dc766b78" = {
      credentialsFile = "/home/riscadoa/.cloudflared/248c8d02-aa20-4b78-bd43-ff97dc766b78.json";
      default = "http_status:404";
    };
  };
}

