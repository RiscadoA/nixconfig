# modules/home/desktop/apps/zed.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Zed home configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.apps.zed;
in
{
  options.modules.desktop.apps.zed.enable = mkEnableOption "zed";

  config = mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
      package = pkgs.unstable.zed-editor;
      mutableUserKeymaps = true;
      mutableUserSettings = true;
      mutableUserTasks = true;
    };
  };
}
