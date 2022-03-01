# hosts/theta/configuration.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Theta system configuration.

{ config, pkgs, options, ... }:
{
  # Modules configuration.
  modules = {
    desktop = {
      slock.enable = true;
      fonts.enable = true;
    };

    services = {
      minecraft = {
        enable = true;
        syncthing.enable = true;
        servers = [ "main" "lihao" ];
      };
      ark.enable = true;
    };
  };

  # Extra packages.
  environment.systemPackages = [
    pkgs.pulsemixer
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Define hostname and enable network manager
  networking = {
    firewall.enable = false;
    wireless.enable = false;
    nameservers = [
      "193.136.164.1"
      "193.136.164.2"
    ];
    interfaces.enp0s31f6 = {
      ipv4 = {
        addresses = [
          {
            address = "193.136.164.197";
            prefixLength = 27;
          }
        ];
        routes = [
          {
            address = "0.0.0.0";
            prefixLength = 0;
            via = "193.136.164.222";
          }
        ];
      };
      ipv6 = {
        addresses = [
          {
            address = "2001:690:2100:82::197";
            prefixLength = 64;
          }
        ];
        routes = [
          {
            address = "::";
            prefixLength = 0;
            via = "2001:690:2100:82::ffff:1";
          }
        ];
      };
    };
  };

  console.useXkbConfig = true;

  services.xserver = {
    enable = true;
    layout = "pt";
    displayManager.startx.enable = true;
  };

  hardware = {
    opengl.enable = true;
    pulseaudio.enable = true; 
  };

  sound.enable = true;

  nix.trustedUsers = [ "root" "@wheel" ];
  users = {
    mutableUsers = true;
    users.root.initialPassword = "123";
    users.riscadoa = {
      isNormalUser = true;
      createHome = true;
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "video" "libvirtd" ];
    };
  };

  services.openssh.enable = true;

  # Required for gtk.
  services.dbus.packages = [ pkgs.gnome3.dconf ];

  security.pki.certificateFiles = [ ../../config/certs/rnl.crt ];
}
