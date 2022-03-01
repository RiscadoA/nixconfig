# modules/home/shell/pass.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# pass home configuration.

{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.shell.pass;
in
{
  options.modules.shell.pass.enable = mkEnableOption "pass";

  config = mkIf cfg.enable {
    programs.password-store.enable = true;
  }; 
}
