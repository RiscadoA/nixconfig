# hosts/mercury/configuration.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Mercury system configuration.

{ config, pkgs, options, inputs, lib, configDir, ... }:
{
  # Modules configuration.
  modules = {
    hardware = {
      arctis9.enable = true;
      qmk.enable = true;
    };

    desktop = {
      hyprland.enable = true;
      greetd.enable = true;
      fonts.enable = true;
      games.steam.enable = true;
    };

    services.minecraft = {
      enable = true;
      servers = [ "create" "castro" ];
    };

    services.tailscale.enable = true;

    # vm.vfio = {
    #   mode = "single";
    #   devices = [ "10de:13c0" "10de:0fbb" ];
    # };
  };

  # Extra packages.
  environment.systemPackages = [
    pkgs.pulsemixer
    pkgs.wineWowPackages.stable
  ];

  services.thermald.enable = true;
  powerManagement.cpuFreqGovernor = "performance";

  # Required by vscode
  services.gnome.gnome-keyring.enable = true;

  boot = {
    kernelParams = [ "quiet" ];

    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        default = "saved";
      };
      efi.canTouchEfiVariables = true;
    };

    binfmt.emulatedSystems = [ "aarch64-linux" ];

    consoleLogLevel = 3;
    #plymouth = {
    #  enable = true;
    #  theme = "breeze";
    #};
  };

  hardware = {
    graphics.enable = true;
    nvidia.open = false;
    nvidia.nvidiaSettings = true;
    nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Required even though we're using Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  # Supposedly better for the ssd
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  networking = {
    firewall.enable = false;
    wireless.enable = false;
    networkmanager = {
      enable = true;
      insertNameservers = [ "1.1.1.1" ];
      unmanaged = [ "enp6s0" ];
    };

    interfaces.enp6s0 = {
      wakeOnLan = {
        enable = true;
        policy = [ "magic" ];
      };
      ipv4 = {
        addresses = [{
          address = "10.0.0.1";
          prefixLength = 32;
        }];
        routes = [{
          address = "10.0.0.2";
          prefixLength = 32;
        }];
      };
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  services.openssh = {
    enable = true;
    startWhenNeeded = true;
  };

  services.openvpn.servers = {
    tecnicoVPN = {
      config = '' config ${configDir}/tecnico.ovpn '';
      autoStart = false;
    };
  };

  services.blueman.enable = true;
  hardware = {
    bluetooth = {
      enable = true;
      input = {
        General = {
          ClassicBondedOnly = false;
        };
      };
    };
    cpu.intel.updateMicrocode = true;
  };

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  virtualisation.docker.enable = true;

  # Required for gtk.
  services.dbus.packages = [ pkgs.dconf ];
}
