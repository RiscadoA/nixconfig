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

  services.actual = {
    enable = true;
    settings.port = 3000;
  };

  services.cloudflared = {
    enable = true;
    tunnels."248c8d02-aa20-4b78-bd43-ff97dc766b78" = {
      credentialsFile = "/home/riscadoa/.cloudflared/248c8d02-aa20-4b78-bd43-ff97dc766b78.json";
      default = "http_status:404";
    };
  };
}

