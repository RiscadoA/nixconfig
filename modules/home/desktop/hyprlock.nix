# modules/home/desktop/hyprlock.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# hyprlock home configuration.

{ lib, config, pkgs, configDir, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.hyprlock;
in
{
  options.modules.desktop.hyprlock.enable = mkEnableOption "hyprlock";

  config = mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
      settings = {
        "$font" = "Monospace";

        general = {
          hide_cursor = true;
        };

        animations = {
          enabled = true;
          bezier = "linear, 1, 1, 0, 0";
          animation = [
            "fadeIn, 1, 5, linear"
            "fadeOut, 1, 5, linear"
            "inputFieldDots, 1, 2, linear"
          ];
        };

        background = {
          monitor = "";
          path = "/home/riscadoa/pictures/wallpapers/current";
          blur_passes = 3;
        };

        input-field = {
          monitor = "";
          size = "20%, 5%";
          outline_thickness = 2;
          outer_color = "rgb(ffffff) rgb(ffffff)";
          inner_color = "rgb(1a1b26)";
          check_color = "rgb(7aa2f7) rgb(7aa2f7)";
          fail_color = "rgb(f7768e) rgb(f7768eff)";

          font_color = "rgb(cfc9c2)";
          fade_on_empty = false;
          rounding = 15;

          font_family = "$font";
          placeholder_text = "Input password...";
          fail_text = "$PAMFAIL";

          dots_spacing = 0.3;

          position = "0, -20";
          halign = "center";
          valign = "center";
        };

        label = [
          {
            monitor = "";
            text = "$TIME";
            font_size = 90;
            font_family = "$font";

            position = "0, -450";
            halign = "center";
            valign = "top";
          }
          {
            monitor = "";
            text = "cmd[update:60000] date +\"%A, %d %B %Y\"";
            font_size = 25;
            font_family = "$font";

            position = "0, -600";
            halign = "center";
            valign = "top";
          }
        ];
      };
    };
    
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };

        listener = [
          {
            timeout = 600;
            on-timeout = "hyprlock";
          }
          {
            timeout = 720;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };
}
