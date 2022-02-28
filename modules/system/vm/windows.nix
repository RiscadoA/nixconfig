# modules/system/vm/windows.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Windows virtual machine configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.vm.windows;
in {
  options.modules.vm.windows.enable = mkEnableOption "windows";

  config = mkIf cfg.enable {
    boot = {
      kernelModules = [ "kvm-intel" "vfio-pci" ];
      blacklistedKernelModules = [ "nouveau" ];
      kernelParams = [ "intel_iommu=on" "vfio-pci.ids=10de:1f15,10de:10f9,10de:1ada,10de:1adb" ]; 
    };
    virtualisation = {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
    };
    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [ virt-manager spice-gtk ];
  };
}
