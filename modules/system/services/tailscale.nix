# modules/system/services/tailscale.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Tailscale system configuration.

{ lib, config, pkgs, ... }:
let
  inherit (builtins) toString;
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.services.tailscale;
in
{
  options.modules.services.tailscale.enable = mkEnableOption "tailscale";

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.tailscale ];

    services.tailscale.enable = true;
  };
}
