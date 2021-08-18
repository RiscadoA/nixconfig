# modules/home/vscode.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# VS Code home configuration.

{ pkgs, ... }:
{
  programs.vscode.enable = true;
  programs.vscode.package = pkgs.vscode-fhs;
}
