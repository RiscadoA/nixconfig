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
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "systemd" ];
        theme = "robbyrussell";
      };
      initExtraFirst = ''
        DISABLE_MAGIC_FUNCTIONS=true

        function convertqb {
            local input=$1
            local output=''${input%.qb}.grd
            quadrados convert -v $input -g $output -w -p $PALETTE
        }
      '';
    };
  };
}
