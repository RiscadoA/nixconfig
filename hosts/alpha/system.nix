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
        users = [ "riscadoa" ];
      };
    };

    services = {
      tailscale.enable = true;
      minecraft = {
        enable = true;
        syncthing.enable = true;
        servers = [ "main" "all" "modded" ];
      };
    };

    #vm.vfio = {
    #  mode = "dual";
    #  devices = [ "10de:1f15" "10de:10f9" "10de:1ada" "10de:1adb" ];
    #};
  };

  # Extra packages.
  environment.systemPackages = [
    pkgs.pulsemixer
    pkgs.wineWowPackages.stable
  ];

  services.openvpn.servers = {
    tecnicoVPN = {
      config = '' config ${configDir}/tecnico.ovpn '';
      autoStart = false;
    };
  };

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

    xkb.layout = "pt";
  };

  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  hardware = {
    bluetooth.enable = true;
    pulseaudio.enable = true;
    cpu.intel.updateMicrocode = true;
  };

  sound.enable = true;

  users = {
    mutableUsers = true;
    users.root.initialPassword = "123";
  };

  virtualisation.docker.enable = true;

  # Required for gtk.
  programs.dconf.enable = true;
  services.dbus.packages = [ pkgs.dconf ];
}
