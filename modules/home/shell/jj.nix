# modules/home/shell/jj.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Jujutsu (jj) home configuration.

{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.shell.jj;
in
{
  options.modules.shell.jj.enable = mkEnableOption "jj";

  config = mkIf cfg.enable {
    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "Ricardo Antunes";
          email = "me@riscadoa.com";
        };
      };
    };
  };
}
