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
    home.file.".config/niri/config.kdl".text = ''
      input {
        keyboard {
          xkb {
            layout "${cfg.keyboardLayout}"
          }
        }
        touchpad {
          natural-scroll
        }
      }

      layout {
        gaps 8
        center-focused-column "never"

        preset-column-widths {
          proportion 0.33333
          proportion 0.5
          proportion 0.66667
        }

        focus-ring {
          width 2
          active-color "#ffffffee"
          inactive-color "#666666aa"
        }

        border {
          off
        }
      }

      spawn-at-startup "wl-paste" "--watch" "cliphist" "store"

      environment {
        XDG_CURRENT_DESKTOP "niri"
        XDG_SESSION_DESKTOP "niri"
      }

      window-rule {
        match app-id="firefox"
        opacity 0.975
      }

      window-rule {
        match app-id="kitty"
        opacity 0.9
      }

      window-rule {
        match app-id="spotify"
        opacity 0.9
      }

      window-rule {
        match app-id="code"
        opacity 0.95
      }

      window-rule {
        match app-id="discord"
        opacity 0.95
      }

      window-rule {
        match app-id="signal"
        opacity 0.95
      }

      window-rule {
        match app-id="^discord$"
        open-on-workspace "4"
      }

      window-rule {
        match app-id="^signal$"
        open-on-workspace "4"
      }

      window-rule {
        match title="flameshot"
        open-floating true
      }

      binds {
        Mod+S { spawn "rofi" "-show" "window" "-show-icons"; }
        Mod+P { spawn "rofi-pass"; }
        Mod+D { spawn "rofi" "-show" "drun" "-show-icons" "-sort"; }
        Mod+Shift+D { spawn "rofi" "-show" "run" "-sort"; }
        Mod+C { spawn "rofi" "-modi" "clipboard:${pkgs.cliphist}/bin/cliphist-rofi-img" "-show" "clipboard" "-show-icons"; }
        Mod+Shift+Q { close-window; }
        Mod+W { fullscreen-window; }
        Mod+Shift+W { maximize-column; }
        Mod+Shift+L { spawn "hyprlock"; }
        Mod+F { toggle-window-floating; }
        Mod+Return { spawn "kitty"; }
        Print { spawn "flameshot" "gui"; }
        Mod+Shift+P { spawn "flameshot" "gui"; }

        Mod+Left { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+Up { focus-window-up; }
        Mod+Down { focus-window-down; }

        Mod+J { focus-window-down; }

        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }

        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }

        Mod+WheelScrollUp { focus-workspace-up; }
        Mod+WheelScrollDown { focus-workspace-down; }

        XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "-l" "1" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86AudioMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86AudioMicMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }
        XF86MonBrightnessUp { spawn "light" "-A" "5"; }
        XF86MonBrightnessDown { spawn "light" "-U" "5"; }

        Mod+Ctrl+Left { spawn "playerctl" "previous"; }
        Mod+Ctrl+Right { spawn "playerctl" "next"; }
        Mod+Ctrl+Up { spawn "playerctl" "play-pause"; }
        Mod+Ctrl+Down { spawn "playerctl" "stop"; }
      }
    '';

    home.pointerCursor.hyprcursor.enable = true;
  };
}
