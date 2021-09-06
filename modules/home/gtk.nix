# modules/home/gtk.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Gtk home configuration.

{ pkgs, ... }:
{
  gtk.enable = true;
  #gtk.theme = {
  #  package = pkgs.gruvbox-dark-gtk;
  #  name = "gruvbox-dark";
  #};
  #gtk.iconTheme = {
  #  package = pkgs.gruvbox-dark-icons-gtk;
  #  name = "oomox-gruvbox-dark";
  #};
  #gtk.gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
}
