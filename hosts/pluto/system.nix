{ config, pkgs, options, inputs, lib, configDir, ... }:
{
  # Modules configuration.
  modules = {
    services.grocy = {
      #enable = true;
      hostName = "pluto.riscadoa.com";
    };
  };
  
  boot.tmp.cleanOnBoot = true;
  
  zramSwap.enable = true;

  networking.domain = "";

  services.openssh.enable = true;
}

