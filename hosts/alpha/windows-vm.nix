# hosts/alpha/windows-vm.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Windows virtual machine configuration.

{ pkgs, ... }:
{
  boot.kernelModules = [ "kvm-intel" "vfio-pci" ];
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.kernelParams = [ "intel_iommu=on" "vfio-pci.ids=10de:1f15,10de:10f9,10de:1ada,10de:1adb" ]; 
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [ virt-manager spice-gtk ];
}
