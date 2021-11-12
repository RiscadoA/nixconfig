# modules/home/vscode.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# VS Code home configuration.

{ pkgs, ... }:

let
  extensions = (with pkgs.vscode-extensions; [
      bbenoist.Nix
      ms-python.python
      ms-vscode-remote.remote-ssh
      ms-vscode.cpptools
    ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
  ];
in
{
  programs.vscode.enable = true;
  programs.vscode.package = pkgs.vscode;
  programs.vscode.extensions = extensions;
}
