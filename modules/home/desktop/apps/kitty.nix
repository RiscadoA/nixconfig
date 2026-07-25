# modules/home/desktop/apps/kitty.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# kitty home configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.desktop.apps.kitty;

  kitty-cwd = pkgs.writeShellScriptBin "kitty-cwd" ''
    set -euo pipefail

    pid=""
    class=""

    if [[ -n "''${NIRI_SOCKET-}" ]]; then
      focused=$(niri msg --json focused-window 2>/dev/null || echo '{}')
      pid=$(${pkgs.jq}/bin/jq -r '.pid // empty' <<< "$focused")
      class=$(${pkgs.jq}/bin/jq -r '.app_id // empty' <<< "$focused")
    fi

    if [[ "$class" == "kitty" && -n "$pid" ]]; then
      children=$(${pkgs.procps}/bin/ps -o pid --ppid "$pid" --no-headers 2>/dev/null || true)
      for child in $children; do
        stdin=$(readlink "/proc/$child/fd/0" 2>/dev/null || true)
        [[ "$stdin" == /dev/pts/* ]] || continue
        cwd=$(readlink "/proc/$child/cwd" 2>/dev/null || true)
        if [[ -d "$cwd" ]]; then
          exec ${pkgs.kitty}/bin/kitty --directory "$cwd"
        fi
      done
    fi

    exec ${pkgs.kitty}/bin/kitty
  '';
in
{
  options.modules.desktop.apps.kitty = {
    enable = mkEnableOption "kitty";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      themeFile = "tokyo_night_night";
      settings = {
        confirm_os_window_close = 0;
      };
    };

    home.packages = [ kitty-cwd ];
  };
}
