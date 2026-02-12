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

  password-store-dir = config.programs.password-store.settings.PASSWORD_STORE_DIR;
  rofi-pass = pkgs.writeShellScriptBin "rofi-pass" ''
    find ${password-store-dir} -type f -name '*.gpg' |
    sed "s|${password-store-dir}/||; s|.gpg$||" |
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
          touchpad = {
            natural_scroll = true;
          };
          follow_mouse = 2;
        };
        exec-once = [
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
          "$mod SHIFT, P, exec, flameshot gui"

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
          "suppress_event maximize, match:class .*"

          # Fix some dragging issues with XWayland
          "no_focus on, match:class ^$, match:title ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0"

          # Fix flameshot
          "move 0 0, match:title (flameshot)"
          "pin on, match:title (flameshot)"
          "decorate off, match:title (flameshot)"
          "stay_focused on, match:title (flameshot)"
          "float on, match:title (flameshot)"
          "opaque on, match:title (flameshot)"
          "no_anim on, match:title (flameshot)"

          # Make some apps transparent
          "opacity 0.9, match:class kitty"
          "opacity 0.975 0.975 1.0, match:class firefox"
          "opacity 0.9, match:class spotify"
          "opacity 0.95, match:class code"
          "opacity 0.95, match:class discord"
          "opacity 0.95, match:class signal"

          # Workspace assignments
          "workspace 4, match:class ^discord$"
          "workspace 4, match:class ^signal$"
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
        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };
        misc = {
          on_focus_under_fullscreen = true;
          focus_on_activate = true;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };
      };
    };

    home.pointerCursor.hyprcursor.enable = true;

    xdg.desktopEntries.wipe-cliphist = {
      name = "Cliphist Wipe";
      genericName = "Wipe Clipboard History";
      exec = "cliphist wipe";
      icon = "edit-clear-history";
      categories = [ "Utility" ];
    };
  };
}
