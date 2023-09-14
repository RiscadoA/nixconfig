# hosts/mercury/configuration.nix
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
    };

    desktop = {
      slock.enable = true;
      fonts.enable = true;
      games.steam.enable = true;
      lightdm = {
        enable = true;
        users = [ "riscadoa" ];
      };
    };

    #services.minecraft = {
    #  enable = true;
    #  syncthing.enable = true;
    #  servers = [ "main" "all" "modded" ];
    #};
    
    vm.vfio = {
      mode = "single";
      devices = [ "10de:13c0" "10de:0fbb" ];
    };
  };

  # Extra packages.
  environment.systemPackages = [
    pkgs.pulsemixer
    pkgs.unstable.grapejuice
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

    consoleLogLevel = 3;
    plymouth = {
      enable = true;
      theme = "breeze";
    };
  };

  hardware = {
    opengl.enable = true;
    nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # Supposedly better for the ssd
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

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

  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    #passwordAuthentication = false;
  };
  
  hardware = {
    bluetooth.enable = true;
    pulseaudio.enable = true;
    cpu.intel.updateMicrocode = true;
  };

  sound.enable = true;

  virtualisation.docker.enable = true;

  # Required for gtk.
  services.dbus.packages = [ pkgs.dconf ];
}
