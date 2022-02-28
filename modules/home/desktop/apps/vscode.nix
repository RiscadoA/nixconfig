# modules/home/desktop/apps/vscode.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# VS Code home configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.apps.vscode;

  extensions = (with pkgs.vscode-extensions; [
      bbenoist.nix
      ms-python.python
      ms-vscode-remote.remote-ssh
      ms-vscode.cpptools
    ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
  ];
in
{
  options.modules.desktop.apps.vscode.enable = mkEnableOption "vscode";

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      extensions = extensions;
    };
  };
}
