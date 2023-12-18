# modules/system/hardware/impermanence.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# root as tmpfs configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.modules.hardware.impermanence;
in
{
  options.modules.hardware.impermanence.enable = mkEnableOption "impermanence";

  config = mkIf cfg.enable {
    # Persistent files
    environment.persistence."/nix/persist" = {
      directories = [
        "/home/riscadoa/nixos"
        "/etc/NetworkManager/system-connections"
        "/var/lib"
        "/var/log"
        "/var/db/sudo/lectured"
        "/srv"
        "/home"
      ];
      files = [
        "/etc/shadow"
        "/etc/machine-id"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
      ];
    };

    fileSystems = {
      "/".options = [ "defaults" "size=2G" "mode=755" ];
      "/nix".neededForBoot = true;
    };
  };
}
