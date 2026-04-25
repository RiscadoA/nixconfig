# modules/home/desktop/niri.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Niri home configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.desktop.niri;
in
{
  options.modules.desktop.niri = {
    enable = mkEnableOption "niri";
    keyboardLayout = mkOption {
      type = types.str;
      default = "us";
      description = "Keyboard layout to use in niri.";
    };
  };

  config = mkIf cfg.enable {
    programs.niri = {
      enable = true;
      package = pkgs.niri;

      settings = {
        spawn-at-startup = [
          { command = [ "wl-paste" "--watch" "cliphist" "store" ]; }
        ];

        input = {
          keyboard.xkb.layout = cfg.keyboardLayout;
          touchpad = {
            tap = true;
            natural-scroll = true;
          };
        };

        # Note: previously had `place-within-backdrop = true` for the
        # wallpaper namespaces, which makes the wallpaper layer render
        # only inside niri's overview backdrop (not on regular
        # workspaces). swaybg/hyprpaper already use the `background`
        # layer-shell layer, which sits below all windows and is visible
        # everywhere — so we don't need a custom rule.
        layer-rules = [];

        layout = {
          gaps = 8;
          # Negative struts pull the working area slightly past the screen
          # edges so the per-column gaps look uniform (otherwise the outer
          # gap visually doubles up on top of the workspace edge).
          struts = {
            left = -1;
            right = -1;
            bottom = -1;
          };
          preset-column-widths = [
            { proportion = 0.33333; }
            { proportion = 0.5; }
            { proportion = 0.66667; }
          ];
          border = {
            enable = true;
            width = 2;
            active.color = "#7aa2f7";
            inactive.color = "#414868";
          };
          focus-ring.enable = false;
          center-focused-column = "never";
        };

        window-rules = [
          {
            geometry-corner-radius = {
              top-left = 12.0;
              top-right = 12.0;
              bottom-left = 12.0;
              bottom-right = 12.0;
            };
            clip-to-geometry = true;
          }
          # Firefox and Spotify request maximize/fullscreen on launch which
          # makes them cover the whole workspace edge-to-edge with no gap or
          # border. Force them into the normal tiled state.
          {
            matches = [
              { app-id = "^firefox$"; }
              { app-id = "^Spotify$"; }
              { app-id = "^spotify$"; }
            ];
            open-maximized = false;
            open-fullscreen = false;
          }
        ];

        workspaces = {
          "home" = {};
        };

        gestures.hot-corners.enable = false;
        overview.workspace-shadow.enable = false;
        prefer-no-csd = true;
        hotkey-overlay.skip-at-startup = true;

        binds = {
          # Launchers
          "Mod+Return".action.spawn = "kitty";
          "Mod+D".action.spawn = "${pkgs.fuzzel}/bin/fuzzel";
          "Mod+Shift+D".action.spawn = [ "${pkgs.fuzzel}/bin/fuzzel" "--dmenu" ];
          "Mod+C".action.spawn = "${pkgs.rofi}/bin/rofi -modi clipboard:cliphist-rofi-img -show clipboard -show-icons";
          "Mod+P".action.spawn = "rofi-pass";
          "Print".action.spawn = "flameshot gui";
          "Mod+Shift+P".action.spawn = "flameshot gui";

          # Meta 
          "Mod+Shift+Slash".action.show-hotkey-overlay = [];
          "Mod+Tab".action.toggle-overview = [];
          "Mod+Shift+Q".action.close-window = [];
          "Mod+Shift+E".action.quit = [];
          "Mod+Shift+L".action.spawn = "hyprlock";

          # Focus
          "Mod+Left".action.focus-column-left = [];
          "Mod+Right".action.focus-column-right = [];
          "Mod+Up".action.focus-window-or-workspace-up = [];
          "Mod+Down".action.focus-window-or-workspace-down = [];

          # Moving
          "Mod+Shift+Left".action.move-column-left = [];
          "Mod+Shift+Right".action.move-column-right = [];
          "Mod+Shift+Up".action.move-window-up-or-to-workspace-up = [];
          "Mod+Shift+Down".action.move-window-down-or-to-workspace-down = [];

          # Sizing
          "Mod+F".action.maximize-column = [];
          "Mod+Shift+F".action.fullscreen-window = [];
          "Mod+V".action.toggle-window-floating = [];
          "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = [];
          "Mod+Minus".action.set-column-width = "-10%";
          "Mod+Equal".action.set-column-width = "+10%";
          "Mod+R".action.switch-preset-column-width = [];

          # Columns
          "Mod+Comma".action.consume-window-into-column = [];
          "Mod+Period".action.expel-window-from-column = [];

          # Monitors
          "Mod+Alt+Left".action.focus-monitor-left = [];
          "Mod+Alt+Right".action.focus-monitor-right = [];

          # Focus workspaces
          "Mod+1".action.focus-workspace = 1;
          "Mod+2".action.focus-workspace = 2;
          "Mod+3".action.focus-workspace = 3;
          "Mod+4".action.focus-workspace = 4;
          "Mod+5".action.focus-workspace = 5;
          "Mod+6".action.focus-workspace = 6;
          "Mod+7".action.focus-workspace = 7;
          "Mod+8".action.focus-workspace = 8;
          "Mod+9".action.focus-workspace = 9;
          "Mod+0".action.focus-workspace = 10;
          "Mod+Shift+1".action.move-column-to-workspace = 1;
          "Mod+Shift+2".action.move-column-to-workspace = 2;
          "Mod+Shift+3".action.move-column-to-workspace = 3;
          "Mod+Shift+4".action.move-column-to-workspace = 4;
          "Mod+Shift+5".action.move-column-to-workspace = 5;
          "Mod+Shift+6".action.move-column-to-workspace = 6;
          "Mod+Shift+7".action.move-column-to-workspace = 7;
          "Mod+Shift+8".action.move-column-to-workspace = 8;
          "Mod+Shift+9".action.move-column-to-workspace = 9;
          "Mod+Shift+0".action.move-column-to-workspace = 10;
          "Mod+WheelScrollUp".action.focus-workspace-up = [];
          "Mod+WheelScrollDown".action.focus-workspace-down = [];

          # Move workspaces
          "Mod+Shift+Ctrl+Left".action.move-workspace-to-monitor-left = [];
          "Mod+Shift+Ctrl+Right".action.move-workspace-to-monitor-right = [];
          "Mod+Shift+Ctrl+Up".action.move-workspace-up = [];
          "Mod+Shift+Ctrl+Down".action.move-workspace-down = [];
          "Mod+Shift+WheelScrollUp".action.move-workspace-up = [];
          "Mod+Shift+WheelScrollDown".action.move-workspace-down = [];

          # Media
          "XF86AudioRaiseVolume".action.spawn = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume".action.spawn = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86AudioMute".action.spawn = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioMicMute".action.spawn = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          "Mod+Ctrl+Left".action.spawn = "playerctl previous";
          "Mod+Ctrl+Right".action.spawn = "playerctl next";
          "Mod+Ctrl+Up".action.spawn = "playerctl play-pause";
          "Mod+Ctrl+Down".action.spawn = "playerctl stop";

          # Brightness
          "XF86MonBrightnessUp".action.spawn = "light -A 5";
          "XF86MonBrightnessDown".action.spawn = "light -U 5";
        };
      };
    };

    home.pointerCursor.hyprcursor.enable = true;
  };
}
