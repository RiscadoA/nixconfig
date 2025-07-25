{ config, pkgs, options, inputs, lib, configDir, ... }:
{
  modules = {
    hardware = {
      arctis9.enable = true;
      backlight.enable = true;
    };

    desktop = {
      hyprland.enable = true;
      sddm = {
        enable = true;
        users = [ "riscadoa" ];
        auto = true;
      };
      fonts.enable = true;
      games.steam = {
        enable = true;
        desktopScaling = 1.6;
      };
    };

    services = {
      tailscale.enable = true;
    };
  };

  environment.systemPackages = [
    pkgs.wineWowPackages.stable
    pkgs.alsa-utils
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

    initrd.systemd.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = [ "quiet" "amdgpu.sg_display=0" ];
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

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
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

  console.keyMap = "pt-latin1";

  services.blueman.enable = true;
  hardware = {
    bluetooth = {
      enable = true;
      package = pkgs.unstable.bluez;
      input = {
        General = {
          ClassicBondedOnly = false;
        };
      };
    };
    cpu.amd.updateMicrocode = true;
  };

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  services.tlp.enable = true;
  services.ntp.enable = true;

  services.logind.extraConfig = ''
    HandlePowerKey=suspend
  '';

  users = {
    mutableUsers = true;
    users.root.initialPassword = "123";
  };

  virtualisation = {
    docker.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        ovmf = {
          enable = true;
          packages = [ pkgs.OVMFFull.fd ];
        };
        swtpm.enable = true;
        runAsRoot = true;
      };
    };
  };

  programs.virt-manager.enable = true;

  # Required for gtk.
  programs.dconf.enable = true;
  services.dbus.packages = [ pkgs.dconf ];
}
