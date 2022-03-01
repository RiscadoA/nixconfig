# modules/system/hardware/arctis.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# steel series arctis 9 configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.modules.hardware.arctis9;
in {
  options.modules.hardware.arctis9.enable = mkEnableOption "arctis9";

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.headsetcontrol ];
    services.udev = {
      packages = [ pkgs.headsetcontrol ];
      extraRules = ''
        ATTRS{idVendor}=="1038", ATTRS{idProduct}=="12c4", ENV{PULSE_PROFILE_SET}="usb-gaming-headset.conf"
      '';
    };
  };
}
