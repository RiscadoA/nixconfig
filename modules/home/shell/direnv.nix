# modules/home/shell/direnv.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# direnv home configuration.

{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.shell.direnv;
in {
  options.modules.shell.direnv.enable = mkEnableOption "direnv";

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
