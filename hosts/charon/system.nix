{ config, pkgs, options, inputs, lib, configDir, ... }:
{
  # Modules configuration.
  modules = {
    services.tailscale.enable = true;
  };
  
  boot.tmp.cleanOnBoot = true;
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  services.openssh.enable = true;
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
}

