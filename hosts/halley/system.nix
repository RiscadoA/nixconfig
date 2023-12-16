{ config, pkgs, options, inputs, lib, configDir, ... }:
{
  modules = {
    hardware = {
      arctis9.enable = true;
      backlight.enable = true;
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
    };
  };

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

    layout = "pt";
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
    };
  };

  hardware = {
    bluetooth.enable = true;
    pulseaudio.enable = true;
    cpu.amd.updateMicrocode = true;
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
