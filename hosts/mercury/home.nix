# hosts/mercury/home.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Home configuration shared by every user of mercury (riscadoa, work, guest).

{ pkgs, ... }:
{
  profiles = {
    cli.enable = true;
    desktop.enable = true;
  };

  modules = {
    desktop = {
      niri = {
        keyboardLayout = "us";
        keyboardVariant = "altgr-intl";
      };

      waybar = {
        compositor = "niri";
        sizeMultiplier = 1.1;
      };

      apps.rofi.enable = true;
    };
  };

  wayland.windowManager.hyprland.settings.input = {
    kb_layout = "us";
    kb_variant = "altgr-intl";
    kb_options = "compose:ralt nodeadkeys";
  };
}