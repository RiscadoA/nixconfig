# modules/system/vm/windows.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Windows virtual machine configuration.

{ lib, config, pkgs, user,... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.vm.windows;
in {
  options.modules.vm.windows.enable = mkEnableOption "windows";

  config = mkIf cfg.enable {
    specialisation.vfio.configuration = {
      boot = {
        kernelModules = [ "kvm-intel" "vfio_pci" "vfio" ];
        initrd.kernelModules = [ "vfio_pci" "vfio" ];
        blacklistedKernelModules = [ "nvidia" "nouveau" ];
        kernelParams = [ "intel_iommu=on" "iommu=pt" "vfio-pci.ids=10de:1f15,10de:10f9,10de:1ada,10de:1adb" ];
      };
    };

    virtualisation = {
      libvirtd = {
        enable = true;
        onBoot = "ignore";
        onShutdown = "shutdown";
        qemu.ovmf.enable = true;
        qemu.runAsRoot = true;
      };
      spiceUSBRedirection.enable = true;
    };

    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [ virt-manager spice-gtk looking-glass-client ];

    systemd.tmpfiles.rules = [ "f /dev/shm/looking-glass 666 ${user} qemu-libvirtd -" ];
  };
}
