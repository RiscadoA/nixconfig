# modules/home/zsh.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# ZSH home configuration.

{ pkgs, ... }:
{
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.initExtra = ''
  '';
  programs.zsh.oh-my-zsh.enable = true;
  programs.zsh.oh-my-zsh.plugins = [
    "git"
    "systemd"
  ];
  programs.zsh.oh-my-zsh.theme = "robbyrussell";
}
