{ config, pkgs, options, inputs, lib, configDir, secrets, ... }:
{
  # Modules configuration.
  modules = {
    services = {
      tailscale.enable = true;
      cubos-discord-bot.enable = true;
    };
  };

  age.secrets = {
    cloudflare-dns-api-token = {
      file = "${secrets}/pluto/cloudflare-dns-api-token.age";
      owner = "firefly-iii";
      group = "nginx";
    };

    firefly-iii-app-key = {
      file = "${secrets}/pluto/firefly-iii-app-key.age";
      owner = "firefly-iii";
      group = "nginx";
    };
    firefly-iii-access-token = {
      file = "${secrets}/pluto/firefly-iii-access-token.age";
      owner = "firefly-iii";
      group = "nginx";
    };
    firefly-iii-enable-banking-app-id = {
      file = "${secrets}/pluto/firefly-iii-enable-banking-app-id.age";
      owner = "firefly-iii";
      group = "nginx";
    };
    firefly-iii-enable-banking-private-key = {
      file = "${secrets}/pluto/firefly-iii-enable-banking.pem.age";
      owner = "firefly-iii";
      group = "nginx";
    };

    cloudflared-credentials.file = "${secrets}/pluto/cloudflared-credentials.json.age";
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
        "CLOUDFLARE_DNS_API_TOKEN_FILE" = config.age.secrets.cloudflare-dns-api-token.path;
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

  services.firefly-iii = {
    package = pkgs.unstable.firefly-iii;
    enable = true;
    enableNginx = true;
    virtualHost = "firefly.home.riscadoa.com";
    settings = {
      APP_KEY_FILE = config.age.secrets.firefly-iii-app-key.path;
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
    package = pkgs.firefly-iii-data-importer;
    enable = true;
    enableNginx = true;
    virtualHost = "importer.firefly.home.riscadoa.com";
    user = "firefly-iii";
    settings = {
      APP_URL = "https://importer.firefly.home.riscadoa.com";
      FIREFLY_III_URL = "https://firefly.home.riscadoa.com";
      FIREFLY_III_ACCESS_TOKEN_FILE = config.age.secrets.firefly-iii-access-token.path;
      ENABLE_BANKING_APP_ID_FILE = config.age.secrets.firefly-iii-enable-banking-app-id.path;
      ENABLE_BANKING_PRIVATE_KEY_FILE = config.age.secrets.firefly-iii-enable-banking-private-key.path;
    };
  };
  security.acme.certs."importer.firefly.home.riscadoa.com".domain = "importer.firefly.home.riscadoa.com";
  services.nginx.virtualHosts."importer.firefly.home.riscadoa.com" = {
    useACMEHost = "importer.firefly.home.riscadoa.com";
    forceSSL = true;
  };

  systemd.tmpfiles.settings."10-firefly-iii-data-importer" =
    let
      dataDir = "/var/lib/${config.systemd.services.firefly-iii-data-importer-setup.serviceConfig.StateDirectory}";
      inherit (config.services.firefly-iii-data-importer) user group;
    in
    lib.attrsets.genAttrs
      [
        "${dataDir}/storage"
        "${dataDir}/storage/app"
        "${dataDir}/storage/app/public"
        "${dataDir}/storage/configurations"
        "${dataDir}/storage/conversion-routines"
        "${dataDir}/storage/debugbar"
        "${dataDir}/storage/framework"
        "${dataDir}/storage/framework/cache"
        "${dataDir}/storage/framework/sessions"
        "${dataDir}/storage/framework/testing"
        "${dataDir}/storage/framework/views"
        "${dataDir}/storage/import-jobs"
        "${dataDir}/storage/jobs"
        "${dataDir}/storage/logs"
        "${dataDir}/storage/submission-routines"
        "${dataDir}/storage/uploads"
        "${dataDir}/cache"
      ]
      (_n: {
        d = {
          group = group;
          mode = "0710";
          user = user;
        };
      })
    // {
      "${dataDir}".d = {
        group = group;
        mode = "0700";
        user = user;
      };
    };

  services.cloudflared = {
    enable = true;
    tunnels."248c8d02-aa20-4b78-bd43-ff97dc766b78" = {
      credentialsFile = config.age.secrets.cloudflared-credentials.path;
      default = "http_status:404";
    };
  };
}

