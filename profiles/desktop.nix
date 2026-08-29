# profiles/desktop.nix
#
# "desktop" profile: graphical baseline (compositor, bar, launcher, apps).
# Host-specific tuning (kb layout, waybar size, ...) stays in the host
# home.nix.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.profiles.desktop;
in
{
  options.profiles.desktop.enable = mkEnableOption "desktop profile";

  config = mkIf cfg.enable {
    modules = {
      desktop = {
        wayland.enable = true;
        niri.enable = true;
        waybar.enable = true;
        hyprlock.enable = true;
        gtk.enable = true;
        qt.enable = true;

        services = {
          wallpaper.enable = true;
          flameshot.enable = true;
        };

        apps = {
          fuzzel.enable = true;
          kitty.enable = true;
          dolphin.enable = true;
          mako.enable = true;
        };
      };

      shell = {
        lf.enable = true;
        tmux.enable = true;
        direnv.enable = true;
        pulsemixer.enable = true;
      };
    };
  };
}