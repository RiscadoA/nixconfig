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
  networking.networkmanager = {
    enable = true;
    unmanaged = [ "enu1u1" ];
  };
  systemd.services.NetworkManager-wait-online.enable = false;

  networking.interfaces.enu1u1.ipv4 = {
    addresses = [{
      address = "10.0.0.2";
      prefixLength = 32;
    }];
    routes = [{
      address = "10.0.0.1";
      prefixLength = 32;
    }];
  };
}
