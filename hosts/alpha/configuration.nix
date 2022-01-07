# hosts/alpha/configuration.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Alpha system configuration.

{ config, pkgs, options, inputs, lib, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{
  imports = [
    ./hardware-configuration.nix
    #./windows-vm.nix

    ../../modules/system/wireguard.nix
    ../../modules/system/lightdm-auto.nix
    ../../modules/system/slock.nix
    ../../modules/system/xmonad.nix
    ../../modules/system/minecraft.nix
  ];

  environment.systemPackages = with pkgs; [
    # Tools
    nvidia-offload
    pulsemixer
    pciutils
    openjdk
    xorg.xmodmap
    headsetcontrol
  ];

  # udev rules
  services.udev.packages = with pkgs; [
    headsetcontrol
  ];

  # Rule for Steelseries Arctis 9
  services.udev.extraRules = ''
    ATTRS{idVendor}=="1038", ATTRS{idProduct}=="12c4", ENV{PULSE_PROFILE_SET}="usb-gaming-headset.conf"
  '';

  programs.steam.enable = true;
  programs.light.enable = true;

  # Required by vscode
  services.gnome.gnome-keyring.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.blacklistedKernelModules = [ "i2c_nvidia_gpu" ];

  # LUKS
  boot.initrd.luks.devices = {
    enc-pv = {
      device = "/dev/disk/by-uuid/a65c0d75-f83b-4a05-80b4-9e6db4e06133";
      preLVM = true;
    };
  };

  # Persistent files
  environment.persistence."/nix/persist" = {
    directories = [
      "/etc/nixos"
      "/etc/NetworkManager/system-connections"
      "/var/lib"
      "/var/log"
      "/var/db/sudo/lectured"
      "/srv"
      "/home"
    ];
    files = [
      "/etc/shadow"
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };

  # Tmpfs
  fileSystems."/".options = [ "defaults" "size=2G" "mode=755" ];
  fileSystems."/nix".neededForBoot = true;

  # Define hostname and enable network manager
  networking.hostName = "alpha";
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;
  networking.networkmanager.insertNameservers = [ "1.1.1.1" ];

  # Set your time zone.
  time.timeZone = "Europe/Lisbon";

  # Keyboard Layout
  console.useXkbConfig = true;
  services.xserver = {
    layout = "pt";
    libinput.enable = true;
    libinput.touchpad.naturalScrolling = true;
    displayManager.sessionCommands = ''
      ${pkgs.xorg.xmodmap}/bin/xmodmap -e 'keycode 135=space'
      ${pkgs.xorg.xmodmap}/bin/xmodmap -e 'keycode 65='
    ''; 
  };

  # Configure NVidia PRIME
  hardware.opengl.enable = true; 
  hardware.nvidia.nvidiaPersistenced = true; 
  hardware.nvidia.prime = {
    offload.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # Create an external display setup.
  specialisation = {
    external-display.configuration = {
      nixpkgs.pkgs = pkgs;
      system.nixos.tags = [ "external-display" ];
      hardware.nvidia.prime.offload.enable = lib.mkForce false;
      hardware.nvidia.powerManagement.enable = lib.mkForce false;
    };
  };

  # Configure xserver
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
  };

  # Enable docker
  virtualisation.docker.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;

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
    users.minecraft = {
      isNormalUser = true;
      createHome = true;
      home = "/srv/minecraft";
    };
  };

  # Set DPI
  services.xserver.dpi = 96;

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

  # Minecraft server
  services.minecraftServers = [ "main" "lihao" ];

  services.syncthing = {
    enable = true;
    user = "minecraft";
    dataDir = "/srv/minecraft";
    configDir = "/srv/minecraft/.config/syncthing";
  };

  # Required for gtk.
  services.dbus.packages = [ pkgs.gnome3.dconf ];

  # Disable firewall.
  networking.firewall.enable = false;

  # Add certificates
  security.pki.certificateFiles = [ ../../certs/rnl.crt ];

  # Version.
  system.stateVersion = "21.11";
}
