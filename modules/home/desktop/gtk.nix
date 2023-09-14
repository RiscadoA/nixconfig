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
      package = pkgs.gruvbox-dark-gtk;
      name = "gruvbox-dark";
    };
    gtk.iconTheme = {
      package = pkgs.gruvbox-dark-icons-gtk;
      name = "oomox-gruvbox-dark";
    };
    gtk.gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
  };
}
