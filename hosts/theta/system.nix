# hosts/theta/configuration.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Theta system configuration.

{ config, pkgs, options, ... }:
{
  modules = {
    desktop.slock.enable = true;
    services = {
      minecraft = {
        enable = true;
        syncthing.enable = true;
        servers = [ "main" "lihao" ];
      };
      ark.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    # Tools
    pulsemixer
    headsetcontrol

    # Game server hosting dependencies
    openjdk
    steamcmd
  ];

  # udev rules
  services.udev.packages = with pkgs; [
    headsetcontrol
  ];

  programs.steam.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Define hostname and enable network manager
  networking.wireless.enable = false;
  networking.nameservers = [
    "193.136.164.1"
    "193.136.164.2"
  ];
  networking.interfaces.enp0s31f6 = {
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

  # Set your time zone.
  time.timeZone = "Europe/Lisbon";

  # Keyboard Layout
  console.useXkbConfig = true;
  services.xserver.layout = "pt";

  # Configure xserver
  hardware.opengl.enable = true; 
  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account.
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

  # Set fonts.
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      noto-fonts 
      noto-fonts-cjk
      font-awesome
    ];

    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Noto Sans CJK JP" ];
      sansSerif = [ "Noto Sans Serif" "Noto Sans CJK JP" ];
      monospace = [ "Noto Sans Mono" "Noto Sans Mono CJK JP" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Required for gtk.
  services.dbus.packages = [ pkgs.gnome3.dconf ];

  # Disable firewall.
  networking.firewall.enable = false;

  # Add certificates
  security.pki.certificateFiles = [ ../../config/certs/rnl.crt ];
}