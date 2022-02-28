# modules/system/hardware/nvidia.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Nvidia gpu configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.modules.vm.windows;
in {
  options.modules.hardware.nvdia = {
    enable = mkEnableOption "nvidia";
  };

  config = mkIf cfg.enable {
    hardware.opengl.enable = true; 
    hardware.nvidia.nvidiaPersistenced = true; 
    hardware.nvidia.prime = {
      offload.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    specialisation.external-display.configuration = {
      nixpkgs.pkgs = pkgs;
      system.nixos.tags = [ "external-display" ];
      hardware.nvidia.prime.offload.enable = lib.mkForce false;
      hardware.nvidia.powerManagement.enable = lib.mkForce false;
    };

    environment.systemPackages = [
      pkgs.writeShellScriptBin "nvidia-offload" ''
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
        exec -a "$0" "$@"
      ''
    ];
  };
}
