# modules/system/services/grocy.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# grocy server system configuration.

{ lib, config, pkgs, ... }:
let
  inherit (builtins) toString;
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.services.grocy;
in
{
  options.modules.services.grocy = {
    enable = mkEnableOption "grocy";
    package = pkgs.unstable.grocy;
    hostName = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    services.grocy = {
      enable = true;
      hostName = cfg.hostName;
      settings.currency = "EUR";
    };

    networking.firewall.allowedTCPPorts = [ 80 ];

    security.acme = {
      acceptTerms = true;
      defaults.email = "acme@riscadoa.com";
    };
  };
}
