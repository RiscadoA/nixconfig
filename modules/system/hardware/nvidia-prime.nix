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
in
{
  options.modules.hardware.nvidia-prime = {
    enable = mkEnableOption "nvidia-prime";
    intelBusId = mkOption { type = types.str; };
    nvidiaBusId = mkOption { type = types.str; };
  };

  config = mkIf cfg.enable {
    hardware = {
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };

      nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = false;
        nvidiaSettings = true;

        package = config.boot.kernelPackages.nvidiaPackages.stable;

        prime = {
          reverseSync.enable = true;
          allowExternalGpu = false;

          inherit (cfg) intelBusId nvidiaBusId;
        };
      };
    };

    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
