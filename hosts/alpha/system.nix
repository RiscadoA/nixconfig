# hosts/alpha/configuration.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Alpha system configuration.

{ config, pkgs, options, inputs, lib, configDir, ... }:
{
  # Modules configuration.
  modules = {
    hardware = {
      arctis9.enable = true;
      impermanence.enable = true;
      broken-spacebar.enable = true;
      backlight.enable = true;
      nvidia-prime = {
        enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    desktop = {
      slock.enable = true;
      fonts.enable = true;
      games.steam.enable = true;
      lightdm = {
        enable = true;
        auto = true;
      };
    };

    services.minecraft = {
      enable = true;
      syncthing.enable = true;
      servers = [ "main" "all" "modded" ];
    };
    
    vm.windows.enable = true;
  };

  # Extra packages.
  environment.systemPackages = [
    pkgs.pulsemixer
  ];

  # Battery saving and preventing overheating.
  services.auto-cpufreq.enable = true;
  services.thermald.enable = true;
  services.throttled.enable = true;
  powerManagement.powertop.enable = true;

  # Required by vscode
  services.gnome.gnome-keyring.enable = true;
  
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd.luks.devices = {
      enc-pv = {
        device = "/dev/disk/by-uuid/a65c0d75-f83b-4a05-80b4-9e6db4e06133";
        preLVM = true;
      };
    };

    kernelModules = [ "coretemp" ];
  };

  networking = {
    firewall.enable = false;
    wireless.enable = false;
    networkmanager = {
      enable = true;
      insertNameservers = [ "1.1.1.1" ];
    };
  };

  console.useXkbConfig = true;

  services.xserver = {
    enable = true;
    dpi = 96;

    layout = "pt";
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
    };
  };

  hardware = {
    bluetooth.enable = true;
    pulseaudio.enable = true;
    cpu.intel.updateMicrocode = true;
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

  virtualisation.docker.enable = true;

  # Required for gtk.
  services.dbus.packages = [ pkgs.dconf ];
}
