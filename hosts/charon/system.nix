{ config, pkgs, options, inputs, lib, configDir, ... }:
{
  # Modules configuration.
  modules = {
    services.tailscale.enable = true;
  };
  
  boot.tmp.cleanOnBoot = true;

  services.openssh.enable = true;
}

