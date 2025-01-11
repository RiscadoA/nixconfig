# modules/home/desktop/services/low-battery-notifier.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# low battery notifier script home configuration.

{ lib, pkgs, config, configDir, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.services.low-battery-notifier;

  script = ''
    battery_info=$(${pkgs.acpi}/bin/acpi -b)

    battery_percentage=$(echo "$battery_info" | ${pkgs.gnugrep}/bin/grep -oP '\d+(?=%)')

    status=$(echo "$battery_info" | ${pkgs.gnugrep}/bin/grep -oP '(Charging|Discharging)')

    if [[ "$status" == "Discharging" && "$battery_percentage" -lt ${builtins.toString cfg.threshold} ]]; then
        ${pkgs.libnotify}/bin/notify-send -t 30000 "Low Battery" "Battery is at ''${battery_percentage}%. Please connect to a charger."
    fi
  '';
in
{
  options.modules.desktop.services.low-battery-notifier = {
    enable = mkEnableOption "low-battery-notifier";
    threshold = lib.mkOption {
      type = lib.types.int;
      default = 25;
      description = "The battery percentage threshold to trigger the notification.";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.timers."low-battery-notifier" = {
      Unit = {
        Description = "Run low battery notifier script periodically";
      };
      Timer = {
        OnBootSec = "5m";
        OnUnitActiveSec = "5m";
        Unit = "low-battery-notifier.service";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };

    systemd.user.services."low-battery-notifier" = {
      Unit = {
        Description = "Low battery notification service";
      };
      Service = {
        ExecStart = "${pkgs.bash}/bin/bash ${pkgs.writeScript "low-battery-notifier" script}";
        Type = "oneshot";
      };
    };
  };
}
