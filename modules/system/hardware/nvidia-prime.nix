# modules/system/hardware/nvidia-prime.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# nvidia prime configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.hardware.nvidia-prime;
in {
  options.modules.hardware.nvidia-prime = {
    enable = mkEnableOption "nvidia-prime";
    intelBusId = mkOption { type = types.str; };
    nvidiaBusId = mkOption { type = types.str; };
  };

  config = mkIf cfg.enable {
    boot.blacklistedKernelModules = [ "i2c_nvidia_gpu" ];
    
    hardware = {
      opengl.enable = true;
      nvidia = {
        nvidiaPersistenced = true; 
        prime = {
          offload.enable = true;
          inherit (cfg) intelBusId nvidiaBusId;
        };
      };
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    specialisation.external-display.configuration = {
      nixpkgs.pkgs = pkgs;
      system.nixos.tags = [ "external-display" ];
      hardware.nvidia = {
        prime.offload.enable = lib.mkForce false;
        powerManagement.enable = lib.mkForce false;
      };
    };

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "nvidia-offload" ''
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
        exec -a "$0" "$@"
      '')
    ];
  };
}
