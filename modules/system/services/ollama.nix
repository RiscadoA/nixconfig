# modules/system/services/ollama.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Ollama system configuration.

{ lib, config, pkgs, ... }:
let
  inherit (builtins) toString;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.services.ollama;
in
{
  options.modules.services.ollama.enable = mkEnableOption "ollama";

  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;
      acceleration = "cuda";
    };
  };
}
