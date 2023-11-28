{ config, pkgs, options, inputs, lib, configDir, ... }:
{
  # Modules configuration.
  modules = {
    services.grocy = {
      enable = true;
      hostName = "grocy.riscadoa.com";
    };

    services.taskserver = {
      enable = true;
      hostName = "pluto.riscadoa.com";
    };

    services.zomboid.enable = true;
  };
  
  boot.tmp.cleanOnBoot = true;
  
  zramSwap.enable = true;

  networking.domain = "";

  services.openssh.enable = true;
}

