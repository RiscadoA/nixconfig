{ config, pkgs, options, inputs, lib, configDir, secrets, ... }:
{
  # Modules configuration.
  modules = {
    services = {
      tailscale.enable = true;
    };
  };

  age.secrets = {
    cloudflare-dns-api-token = {
      file = "${secrets}/pluto/cloudflare-dns-api-token.age";
      owner = "nginx";
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
        
        rewrite name actual.home.riscadoa.com pluto.home.riscadoa.com
        rewrite name mealie.home.riscadoa.com pluto.home.riscadoa.com
        hosts {
          100.121.196.112 synology.home.riscadoa.com
          100.126.246.110 pluto.home.riscadoa.com
          100.124.202.87 mercury.home.riscadoa.com
          fallthrough
        }
      }
    '';
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # Automatic updates & garbage collection.
  system.autoUpgrade = {
    enable = true;
    flake = "github:RiscadoA/nixconfig";
    # Deploy exactly what is pushed to GitHub; never bump inputs on the box.
    # Bump the lock manually with `nix flake update` when desired.
    upgrade = false;
    runGarbageCollection = true;
  };

  nix.gc = {
    automatic = true;
    # Keep a month of rollback generations.
    options = "--delete-older-than 30d";
  };

  nix.settings.auto-optimise-store = true;

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
  };

  services.actual = {
    package = pkgs.unstable.actual-server;
    enable = true;
    settings.port = 3000;
  };
  security.acme.certs."actual.home.riscadoa.com".domain = "actual.home.riscadoa.com";
  services.nginx.virtualHosts."actual.home.riscadoa.com" = {
    useACMEHost = "actual.home.riscadoa.com";
    forceSSL = true;
    locations."/".proxyPass = "http://localhost:3000";
  };

  services.mealie = {
    enable = true;
    port = 3001;
    database.createLocally = true;
  };
  security.acme.certs."mealie.home.riscadoa.com".domain = "mealie.home.riscadoa.com";
  services.nginx.virtualHosts."mealie.home.riscadoa.com" = {
    useACMEHost = "mealie.home.riscadoa.com";
    forceSSL = true;
    locations."/".proxyPass = "http://localhost:3001";
  };

  services.cloudflared = {
    enable = true;
    tunnels."248c8d02-aa20-4b78-bd43-ff97dc766b78" = {
      credentialsFile = config.age.secrets.cloudflared-credentials.path;
      default = "http_status:404";
    };
  };
}

