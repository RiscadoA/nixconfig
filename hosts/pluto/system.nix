{ config, pkgs, options, inputs, lib, configDir, secrets, ... }:
{
  # Modules configuration.
  modules = {
    services = {
      tailscale.enable = true;
      cubos-discord-bot.enable = true;
    };
  };

  boot.kernelModules = [ "fuse" ];

  programs.fuse.userAllowOther = true;

  environment.systemPackages = with pkgs; [
    nfs-utils
    gocryptfs
    fuse
  ];

  age.secrets = {
    cloudflare-dns-api-token = {
      file = "${secrets}/pluto/cloudflare-dns-api-token.age";
      owner = "root";
      group = "root";
    };

    immich-gocryptfs-password = {
      file = "${secrets}/pluto/immich-gocryptfs-password.age";
      owner = "root";
      group = "root";
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
        rewrite name immich.home.riscadoa.com pluto.home.riscadoa.com
        rewrite name droby.home.riscadoa.com pluto.home.riscadoa.com
        rewrite name opencode.home.riscadoa.com pluto.home.riscadoa.com
        
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

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "acme@riscadoa.com";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      credentialFiles = {
        "CLOUDFLARE_DNS_API_TOKEN_FILE" = config.age.secrets.cloudflare-dns-api-token.path;
      };
      group = "root";
    };
  };

  services.openssh.enable = true;
  services.syncthing.enable = true;

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_18;
    ensureDatabases = [ "immich" ];
    ensureUsers = [
      {
        name = "immich";
        ensureDBOwnership = true;
      }
    ];
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

  fileSystems."/mnt/synology-immich" = {
    device = "synology.home.riscadoa.com:/volume1/Immich";
    fsType = "nfs";
    options = [ "defaults" "x-systemd.requires=network.target" ];
  };

  systemd.services.immich-gocryptfs = {
    description = "Mount gocryptfs for Immich";
    after = [ "mnt-synology-immich.mount" "network.target" ];
    wants = [ "mnt-synology-immich.mount" ];
    requiredBy = [ "immich-server.service" "immich-machine-learning.service" ];
    serviceConfig = {
      Type = "forking";
      ExecStartPre = [
        "+${pkgs.coreutils}/bin/mkdir -p /var/lib/immich"
        "+${pkgs.bash}/bin/bash -c 'if [ ! -f /mnt/synology-immich/gocryptfs.conf ]; then ${pkgs.gocryptfs}/bin/gocryptfs -init -passfile ${config.age.secrets.immich-gocryptfs-password.path} /mnt/synology-immich; fi'"
      ];
      ExecStart = "+${pkgs.bash}/bin/bash -c '${pkgs.gocryptfs}/bin/gocryptfs -allow_other -sharedstorage -passfile ${config.age.secrets.immich-gocryptfs-password.path} /mnt/synology-immich /var/lib/immich'";
      ExecStop = "+${pkgs.fuse}/bin/fusermount -u /var/lib/immich";
    };
  };

  services.immich = {
    enable = true;
    mediaLocation = "/var/lib/immich";
    database = {
      enable = true;
      createDB = true;
      enableVectors = false;
    };
    settings = {
      IMMICH_TRUSTED_PROXIES = "**";
    };
    port = 2283;
  };

  security.acme.certs."immich.home.riscadoa.com".domain = "immich.home.riscadoa.com";
  services.nginx.virtualHosts."immich.home.riscadoa.com" = {
    useACMEHost = "immich.home.riscadoa.com";
    forceSSL = true;
    extraConfig = ''
      client_max_body_size 50000M;
    '';
    locations."/" = {
      proxyPass = "http://[::1]:2283";
      proxyWebsockets = true;
      recommendedProxySettings = true;
      extraConfig = ''
        proxy_read_timeout 600s;
        proxy_send_timeout 600s;
        send_timeout 600s;
      '';
    };
  };

  # services.droby = {
  #   enable = true;
  #   port = 3002;
  #   database.createLocally = true;
  # };
  # security.acme.certs."droby.home.riscadoa.com".domain = "droby.home.riscadoa.com";
  # services.nginx.virtualHosts."droby.home.riscadoa.com" = {
  #   useACMEHost = "droby.home.riscadoa.com";
  #   forceSSL = true;
  #   locations."/".proxyPass = "http://localhost:3002";
  # };

  services.nginx.virtualHosts."opencode.home.riscadoa.com" = {
    useACMEHost = "opencode.home.riscadoa.com";
    forceSSL = true;
    locations."/".proxyPass = "http://mercury.home.riscadoa.com:42424";
  };
  security.acme.certs."opencode.home.riscadoa.com".domain = "opencode.home.riscadoa.com";

  services.cloudflared = {
    enable = true;
    tunnels."248c8d02-aa20-4b78-bd43-ff97dc766b78" = {
      credentialsFile = config.age.secrets.cloudflared-credentials.path;
      default = "http_status:404";
    };
  };
}

