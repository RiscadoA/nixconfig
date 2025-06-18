# modules/home/desktop/gtk.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# GTK home configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.gtk;
in
{
  options.modules.desktop.gtk.enable = mkEnableOption "gtk";

  config = mkIf cfg.enable {
    gtk.enable = true;
    gtk.theme = {
      package = pkgs.tokyonight-gtk-theme;
      name = "Tokyonight-Dark"; 
    };
    gtk.iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    gtk.cursorTheme = {
      name = "Bibata-Original-Classic";
      package = pkgs.bibata-cursors;
    };
    gtk.gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    home.sessionVariables.GTK_THEME = "Tokyonight-Dark";
  
    home.pointerCursor = {
      name = "Bibata-Original-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };
}
