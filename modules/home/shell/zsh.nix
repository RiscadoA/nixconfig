# modules/home/shell/zsh.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# ZSH home configuration.

{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.shell.zsh;
in
{
  options.modules.shell.zsh.enable = mkEnableOption "zsh";

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "systemd" ];
        theme = "robyrussell";
      };
    };
  }; 
}
