# modules/system/services/taskserver.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# taskserver server system configuration.

{ lib, config, pkgs, ... }:
let
  inherit (builtins) toString;
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.services.taskserver;
in
{
  options.modules.services.taskserver = {
    enable = mkEnableOption "taskserver";
    package = pkgs.unstable.taskserver;
    hostName = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    services.taskserver = {
      enable = true;
      fqdn = cfg.hostName;
      listenHost = cfg.hostName;
      organisations.home.users = [ "riscadoa" ];
      openFirewall = true;
    };
  };
}
