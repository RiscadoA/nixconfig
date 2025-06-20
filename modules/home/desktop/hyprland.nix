# modules/home/desktop/hyprland.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# hyprland home configuration.

{ lib, config, pkgs, configDir, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.hyprland;

  rofi-pass = pkgs.writeShellScriptBin "rofi-pass" ''
    find $PASSWORD_STORE_DIR -type f -name '*.gpg' |
    sed "s|''${PASSWORD_STORE_DIR}/||; s|\.gpg$||" |
    rofi -i -dmenu -p pass |
    xargs -n 1 pass show 2> /dev/null |
    head -n 1 |
    wl-copy --sensitive
  '';
in
{
  options.modules.desktop.hyprland.enable = mkEnableOption "hyprland";

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.playerctl
      pkgs.cliphist
      pkgs.wl-clipboard
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      portalPackage = null;
      xwayland.enable = true;
      settings = {
        "$mod" = "SUPER";
        general = {
          gaps_out = "2,4,4,4";
          gaps_in = 3;
          "col.active_border" = "rgba(ffffffee) rgba(ffffffee) 0deg";
          "col.inactive_border" = "rgba(666666aa) rgba(666666aa) 0deg";
        };
        decoration = {
          rounding = 4;
        };
        input = {
          kb_layout = "pt";
          touchpad = {
            natural_scroll = true;
          };
          follow_mouse = 2;
        };
        exec-once = [
          "[workspace 1 silent] kitty"
          "[workspace 3 silent] firefox"
          "[workspace 4 silent] discord"
          "[workspace 6 silent] spotify"
          "wl-paste --watch cliphist store"
        ];
        monitor = ", highrr, auto, auto";
        bind = [
          "$mod, S, exec, rofi -show window -show-icons"
          "$mod, P, exec, ${rofi-pass}/bin/rofi-pass"
          "$mod, D, exec, rofi -show drun -show-icons -sort"
          "$mod SHIFT, D, exec, rofi -show run -sort"
          "$mod, C, exec, rofi -modi clipboard:${pkgs.cliphist}/bin/cliphist-rofi-img -show clipboard -show-icons"
          "$mod SHIFT, Q, killactive,"
          "$mod, W, fullscreen, 1"
          "$mod SHIFT, W, fullscreen, 0"
          "$mod SHIFT, L, exec, hyprlock"
          "$mod, F, togglefloating,"
          "$mod, O, pseudo,"
          "$mod, L, swapsplit,"
          "$mod, Return, exec, kitty"
          ", Print, exec, flameshot gui"

          # Move focus with arrow keys
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          # Focus on the next window
          "$mod, J, cyclenext, "

          # Switch to workspace with number keys
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"

          # Move active window to another workspace
          "$mod SHIFT, 1, movetoworkspacesilent, 1"
          "$mod SHIFT, 2, movetoworkspacesilent, 2"
          "$mod SHIFT, 3, movetoworkspacesilent, 3"
          "$mod SHIFT, 4, movetoworkspacesilent, 4"
          "$mod SHIFT, 5, movetoworkspacesilent, 5"
          "$mod SHIFT, 6, movetoworkspacesilent, 6"

          # Move workspace with wheel scroll
          "$mod, mouse_up, workspace, e+1"
          "$mod, mouse_down, workspace, e-1"
        ];
        bindm = [
          # Move/resize windows with mouse buttons and dragging
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
        bindel = [
          # Laptop multimedia keys
          ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86MonBrightnessUp, exec, light -A 5"
          ",XF86MonBrightnessDown, exec, light -U 5"
        ];
        bindl = [
          # Music player controls
          "$mod CTRL, left, exec, playerctl previous"
          "$mod CTRL, right, exec, playerctl next"
          "$mod CTRL, up, exec, playerctl play-pause"
          "$mod CTRL, down, exec, playerctl stop"
        ];
        windowrule = [
          # Ignore maximize requests from apps.
          "suppressevent maximize, class:.*"

          # Fix some dragging issues with XWayland
          "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

          # Fix flameshot
          "move 0 0,class:(flameshot)"
          "pin,class:(flameshot)"
          "noborder,class:(flameshot)"
          "stayfocused,class:(flameshot)"
          "float,class:(flameshot)"
          "opaque,class:(flameshot)"
          "noanim,class:(flameshot)"

          # Make some apps transparent
          "opacity 0.9, class:kitty"
          "opacity 0.975 0.975 1.0, class:firefox"
          "opacity 0.9, class:spotify"
          "opacity 0.95, class:code"
          "opacity 0.95, class:discord"
        ];
        windowrulev2 = [
          "workspace 4, class:^(discord)$"
        ];
        env = [
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "GDK_BACKEND,wayland,x11,*"
          "NIXOS_OZONE_WL,1"
          "QT_QPA_PLATFORM,wayland"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          "QT_AUTO_SCREEN_SCALE_FACTOR,1"
          "MOZ_ENABLE_WAYLAND,1"
        ];
        xwayland = {
          force_zero_scaling = true;
        };
        misc = {
          focus_on_activate = true;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };
      };
    };

    home.pointerCursor.hyprcursor.enable = true;
  };
}
