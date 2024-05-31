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

      taskserver = {
        enable = true;
        hostName = "pluto.riscadoa.com";
      };

      mover = {
        enable = true;
        hostName = "api.flyptmover.com";
      };
    };
  };

  boot.tmp.cleanOnBoot = true;

  zramSwap.enable = true;

  networking.domain = "";

  services.openssh.enable = true;
  services.syncthing.enable = true;
}

