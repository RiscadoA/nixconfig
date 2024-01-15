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

  # Required by vscode
  services.gnome.gnome-keyring.enable = true;

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;

      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
      };
    };

    initrd = {
      systemd.enable = true;

      luks.devices."luks-19e4635a-716a-44c4-82c6-0fe2e33c034a" = {
        device = "/dev/disk/by-uuid/19e4635a-716a-44c4-82c6-0fe2e33c034a";
        allowDiscards = true;
      };
    };

    kernelPackages = pkgs.linuxPackages_6_6;
    kernelParams = [ "quiet" ];
    consoleLogLevel = 3;
    plymouth = {
      enable = true;
      theme = "breeze";
      extraConfig = ''
        DeviceScale=1
      '';
    };
  };

  networking = {
    firewall.enable = false;
    wireless.enable = false;
    networkmanager = {
      enable = true;
    };
    nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = [ pkgs.amdvlk ];
    extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
  };

  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    extraConfig = ''
      DNSOverTLS=yes
    '';
  };

  console.useXkbConfig = true;

  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    dpi = 140;

    layout = "pt";
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      package = pkgs.unstable.bluez;
    };
    pulseaudio.enable = true;
    cpu.amd.updateMicrocode = true;
  };

  services.tlp.enable = true;
  services.ntp.enable = true;

  services.logind.extraConfig = ''
    HandlePowerKey=suspend
  '';

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
