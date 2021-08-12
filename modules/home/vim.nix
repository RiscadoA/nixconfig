# modules/home/vim.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Vim home configuration.

{ pkgs, ... }:
{
  programs.vim.enable = true;
  programs.vim.plugins = with pkgs.vimPlugins; [ vim-nix ];
  home.sessionVariables = {
    EDITOR = "vim";
  };
}
