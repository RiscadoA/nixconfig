# modules/home/shell/vim.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Vim home configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.shell.vim;
in {
  options.modules.shell.vim.enable = mkEnableOption "vim";

  config = mkIf cfg.enable {
    programs.vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ vim-nix ];
    };

    home.sessionVariables = {
      EDITOR = "vim";
    };
  };
}
