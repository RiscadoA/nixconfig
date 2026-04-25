# modules/home/desktop/wayland.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Generic Wayland home configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.wayland;
in
{
  options.modules.desktop.wayland.enable = mkEnableOption "wayland";

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.playerctl
      pkgs.cliphist
      pkgs.wl-clipboard
    ];

    home.sessionVariables = {
      XDG_SESSION_TYPE = "wayland";
      GDK_BACKEND = "wayland,x11,*";
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };

    xdg.desktopEntries.wipe-cliphist = {
      name = "Cliphist Wipe";
      genericName = "Wipe Clipboard History";
      exec = "cliphist wipe";
      icon = "edit-clear-history";
      categories = [ "Utility" ];
    };
  };
}
