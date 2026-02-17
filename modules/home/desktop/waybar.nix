# modules/home/desktop/waybar.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# waybar home configuration.

{ lib, config, pkgs, configDir, secrets, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf mkMerge;
  cfg = config.modules.desktop.waybar;

  text-color = "#cfc9c2";
  text-hovered-color = "#ffffff";
  text-active-color = "#ffffff";
  background-color = "#1a1b26";
  background-hovered-color = "#414868";
  background-active-color = "#7aa2f7";

  string-dim = value: builtins.toString (value * cfg.sizeMultiplier);
  float-dim = value: value * cfg.sizeMultiplier;
  int-dim = value: builtins.ceil (value * cfg.sizeMultiplier);

  base-clock-calendar = {
    tooltip-format = "<tt><small>{calendar}</small></tt>";
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
in
{
  options.modules.desktop.waybar = {
    enable = mkEnableOption "waybar";
    sizeMultiplier = mkOption {
      type = types.float;
      default = 1.0;
      description = "Multiplier for the size of the Waybar icons, fonts and other elements.";
      example = 2.0;
    };
    compact = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to use a compact layout for the Waybar.";
      example = true;
    };
  };

  config = mkIf cfg.enable {
    age.secrets = {
      gmail-username.file = "${secrets}/gmail-username.age";
      gmail-password.file = "${secrets}/gmail-password.age";
    };

    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = {
        mainBar = {
          layer = "bottom";
          position = "top";
          height = int-dim 34;
          spacing = 0;
          modules-left = (if cfg.compact then [] else [ "custom/power" ]) ++
            [ "hyprland/workspaces" "tray" ];
          modules-center = [ "hyprland/window" ];
          modules-right = [ "custom/mail" "wireplumber" "network" "battery" ]
            ++ (if cfg.compact then [ "clock" ] else [ "clock#time" "clock#calendar" ]);

          "custom/power" = {
            format = "";
            tooltip = false;
            menu = "on-click";
            menu-file = configDir + "/waybar/power.xml";
            menu-actions = {
              logout = "uwsm stop";
              shutdown = "shutdown now";
              reboot = "reboot";
            };
          };

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
            icon-size = float-dim 17;
          };

          tray = {
            icon-size = int-dim 17;
            spacing = 0;
            show-passive-items = true;
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

          clock = mkMerge [
            base-clock-calendar
            {
              format = " {:%H:%M}";
              format-alt =" {:%d-%m-%Y}";
            }
          ];

          "clock#time" = {
            interval = 1;
            format = " {:%H:%M:%S}";
          };

          "clock#calendar" = mkMerge [
            base-clock-calendar
            {
              format = " {:%d-%m-%Y}";
            }
          ];

          network = {
            family = "ipv4";
            format-ethernet = if cfg.compact then "" else " {ipaddr}";
            format-wifi = if cfg.compact then "" else " {essid}";
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
            exec = "GMAIL_USERNAME_FILE=${config.age.secrets.gmail-username.path} GMAIL_PASSWORD_FILE=${config.age.secrets.gmail-password.path} /home/riscadoa/nixos/bin/sb-gmail.sh";
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
          font-family: "Noto Sans Mono", "Font Awesome 7 Free", "Font Awesome 7 Free Solid";
          font-size: ${string-dim 14}px;
          color: ${text-color};
        }

        #custom-power,
        #workspaces,
        #tray,
        #window,
        #custom-mail,
        #wireplumber,
        #network,
        #battery,
        #clock {
          background-color: ${background-color};
          border-radius: ${string-dim 4}px;
          margin: ${string-dim 4}px ${string-dim 4}px;
          border: ${string-dim 1}px solid rgba(102, 102, 102, 0.67);
          box-shadow: 0em 0em ${string-dim 2}px black;
        }

        #custom-power,
        #custom-mail,
        #wireplumber,
        #network,
        #battery,
        #clock {
          padding: 0px ${string-dim 5}px;
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
          padding: 0px ${string-dim 5}px;
          border-radius: 0;
        }

        #workspaces button:first-child {
          border-radius: ${string-dim 4}px 0 0 ${string-dim 4}px;
        }

        #workspaces button:last-child {
          border-radius: 0 ${string-dim 4}px ${string-dim 4}px 0;
        }

        #waybar.empty #window {
          border: none;
          box-shadow: none;
        }

        #waybar:not(.empty) #window {
          color: ${text-color};
          padding: 0px ${string-dim 5}px;
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
          padding: 0px ${string-dim 5}px;
          border-radius: 0;
        }

        #tray *:first-child:not(:only-child) {
          border-radius: ${string-dim 4}px 0 0 ${string-dim 4}px;
        }

        #tray *:last-child:not(:only-child) {
          border-radius: 0 ${string-dim 4}px ${string-dim 4}px 0;
        }

        #tray *:only-child {
          border-radius: ${string-dim 4}px;
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
      '';
    };
  };
}
