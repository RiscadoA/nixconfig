# modules/home/desktop/waybar.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# waybar home configuration.

{ lib, config, pkgs, configDir, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.desktop.waybar;

  text-color = "#cfc9c2";
  text-hovered-color = "#ffffff";
  text-active-color = "#ffffff";
  background-color = "#1a1b26";
  background-hovered-color = "#414868";
  background-active-color = "#7aa2f7";
in
{
  options.modules.desktop.waybar.enable = mkEnableOption "waybar";

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 34;
          spacing = 0;
          modules-left = [ "hyprland/workspaces" "tray" ];
          modules-center = [ "hyprland/window" ];
          modules-right = [ "custom/mail" "wireplumber" "backlight" "temperature" "network" "battery" "clock" ];

          "hyprland/workspaces" = {
            disable-scroll = false;
            all-outputs = true;
            format = "{icon}";
            persistent-workspaces = {
              "*" = [1 2 3 4 5 6];
            };
            format-icons = {
              "1" = "";
              "2" = "";
              "3" = "";
              "4" = "";
              "5" = "";
              "6" = "";
            };
          };

          "hyprland/window" = {
            icon = true;
            icon-size = 17;
          };

          tray = {
            icon-size = 17;
            spacing = 0;
            show-passive-items = true;
          };

          backlight = {
            format = " {percent}%";
          };

          battery = {
            states = {
              good = 90;
              warning = 50;
              critical = 20;
            };
            format = "{icon} {capacity}%";
            format-full = "{icon} {capacity}%";
            format-charging = " {capacity}%";
            format-plugged = " {capacity}%";
            format-alt = "{icon} {time}";
            format-icons = ["" "" "" "" ""];
          };

          clock = {
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            format-alt = "{:%d-%m-%Y}";
            calendar = {
              mode-mon-col = 3;
              weeks-pos = "right";
              on-scroll = 1;
              format = {
                months = "<b>{}</b>";
                days = "{}";
                weeks = "<b>W{}</b>";
                weekdays = "<b>{}</b>";
                today = "<b><u>{}</u></b>";
              };
            };
            actions = {
              on-click-right = "mode";
              on-scroll-up = "shift_up";
              on-scroll-down = "shift_down";
            };
          };

          temperature = {
            critical-threshold = 80;
            format = "{icon} {temperatureC}°C";
            format-icons = ["" "" "" "" ""];
          };

          network = {
            family = "ipv4";
            format-ethernet = "";
            format-wifi = "";
            format-disconnected = " Disconnected";
            format-disabled = " Disabled";
            tooltip-format-ethernet = "<big>{ifname}</big>\n<tt><small>{ipaddr}</small></tt>";
            tooltip-format-wifi = "<big>{essid}</big>\n<tt><small>{ipaddr}</small></tt>\n<small>Signal: {signalStrength}%</small>";
          };

          wireplumber = {
            format = "{icon} {volume}%";
            format-icons = ["" "" ""];
            format-muted = " {volume}%";
            on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          };

          "custom/mail" = {
            exec = "/home/riscadoa/nixos/bin/sb-gmail.sh";
            interval = 30;
            tooltip = false;
          };
        };
      };
      style = ''
        #waybar {
          background: transparent;
          border: none;
          box-shadow: none;
          font-family: "Noto Sans Mono", "Font Awesome 6 Free", "Font Awesome 6 Free Solid";
          font-size: 14px;
          color: ${text-color};
        }

        #workspaces,
        #tray,
        #window,
        #custom-mail,
        #wireplumber,
        #network,
        #battery,
        #backlight,
        #temperature,
        #clock {
          background-color: ${background-color};
          border-radius: 4px;
          margin: 4px 4px;
        }

        #custom-mail,
        #wireplumber,
        #network,
        #battery,
        #backlight,
        #temperature,
        #clock {
          padding: 0px 5px;
        }

        #workspaces button:hover {
          color: ${text-hovered-color};
          background-color: ${background-hovered-color};
        }

        #workspaces button.active {
          color: ${text-active-color};
          background-color: ${background-active-color};
        }

        #workspaces button {
          color: ${text-color};
          background: transparent;
          border: none;
          margin: 0;
          padding: 0px 5px;
          border-radius: 0;
        }

        #workspaces button:first-child {
          border-radius: 4px 0 0 4px;
        }

        #workspaces button:last-child {
          border-radius: 0 4px 4px 0;
        }

        #waybar:not(.empty) #window {
          color: ${text-color};
          padding: 0px 5px;
        }

        #waybar.fullscreen #window {
          color: ${text-active-color};
          background-color: ${background-active-color};
        }

        #tray *:hover {
          color: ${text-hovered-color};
          background-color: ${background-hovered-color};
        }

        #tray * {
          margin: 0;
          padding: 0px 5px;
          border-radius: 0;
        }

        #tray *:first-child:not(:only-child) {
          border-radius: 4px 0 0 4px;
        }

        #tray *:last-child:not(:only-child) {
          border-radius: 0 4px 4px 0;
        }

        #tray *:only-child {
          border-radius: 4px;
        }

        #tray .passive {
          -gtk-icon-effect: dim;
        }

        #tray .needs-attention {
          -gtk-icon-effect: highlight;
        }

        #battery.charging, #battery.plugged {
            background-color: #9ece6a;
            color: #282828;
        }

        #battery.warning:not(.charging) {
          background-color: #e0af68;
          color: #282828;
        }

        @keyframes blink {
            to {
                background-color: #282828;
                color: ${text-color};
            }
        }

        #battery.critical:not(.charging) {
          background-color: #cc241d;
          color: ${text-color};
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: steps(12);
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        #temperature.critical {
          background-color: #cc241d;
          color: #282828;
        }
      '';
    };
  };
}
