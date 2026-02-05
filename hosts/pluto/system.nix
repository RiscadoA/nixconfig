{ config, pkgs, options, inputs, lib, configDir, ... }:
{
  # Modules configuration.
  modules = {
    services = {
      tailscale.enable = true;

      grocy = {
        enable = true;
        hostName = "grocy.riscadoa.com";
      };

      cubos-discord-bot.enable = true;
    };
  };

  boot.tmp.cleanOnBoot = true;

  zramSwap.enable = true;

  networking.domain = "";

  services.openssh.enable = true;
  services.syncthing.enable = true;

  services.minecraft-server = {
    enable = true;
    eula = true;
    package = pkgs.unstable.minecraft-server;
    declarative = true;
    openFirewall = true;

    serverProperties = {
      motd = "Castrocraft";
      gamemode = "survival";
      difficulty = "hard";
      white-list = true;
    };

    whitelist = {
      RiscadoA = "572f7bed-9404-4250-bc7f-3f2d43bb1eb7";
    };
  };
}

