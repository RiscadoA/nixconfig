{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/0831a921-b42f-432b-9f1e-5d2e5f2e89ea";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-e80ec446-adf3-479f-86c0-21d0a78facbe".device = "/dev/disk/by-uuid/e80ec446-adf3-479f-86c0-21d0a78facbe";

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/F45B-FFA6";
      fsType = "vfat";
    };

  swapDevices =
    [{
      device = "/dev/disk/by-uuid/b4123493-3143-42c8-bec3-e88805752074";
      encrypted = {
        enable = true;
        keyFile = "/sysroot/root/swap.key";
        label = "luks-19e4635a-716a-44c4-82c6-0fe2e33c034a";
        blkDev = "/dev/disk/by-uuid/19e4635a-716a-44c4-82c6-0fe2e33c034a";
      };
    }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
