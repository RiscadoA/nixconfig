# modules/home/desktop/apps/discord.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Discord home configuration.
#
# Custom tray icon configuration fetched from https://gist.github.com/InternetUnexplorer/364432d6d54b6362004ddb37c9fe686a.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.apps.discord;
  tray-icons = pkgs.runCommand "discord-tray-icons" { } ''
    ICON_THEME="${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark"
    ICON_SVG_SIZE=16
    ICON_PNG_SIZE=128
    ICONS=("tray"
           "tray-connected"
           "tray-deafened"
           "tray-muted"
           "tray-speaking"
           "tray-unread")
    mkdir -p $out
    icon_dir="$ICON_THEME/''${ICON_SVG_SIZE}x''${ICON_SVG_SIZE}/panel"
    for icon in "''${ICONS[@]}"; do
      ${pkgs.librsvg}/bin/rsvg-convert \
        -w $ICON_PNG_SIZE              \
        -h $ICON_PNG_SIZE              \
        -f png                         \
        "$icon_dir/discord-$icon.svg"  \
        > "$out/$icon.png"
    done
  '';

  fix-tray-icons = pkgs.writers.writeBash "fix-discord-tray-icons" ''
    set -euo pipefail
    shopt -s nullglob
    patch_asar_file() {
      unpacked="$(mktemp -d)"
      ${pkgs.nodePackages.asar}/bin/asar extract "$1" "$unpacked"
      cp ${tray-icons}/* "$unpacked/app/images/systemtray/linux/"
      ${pkgs.nodePackages.asar}/bin/asar pack "$unpacked" "$1"
      rm -r "$unpacked"
    }
    config_dir="''${XDG_CONFIG_HOME:-$HOME/.config}"/''${1//-/}
    [ -d "$config_dir" ] || exit 0
    for module_dir in "$config_dir"/*/modules/discord_desktop_core; do
      cd "$module_dir"
      ! sha256sum --status --check core.asar.sha256 2> /dev/null || continue
      echo "(fix-tray-icons) Patching tray icons in '$module_dir/core.asar'..."
      patch_asar_file core.asar
      sha256sum core.asar > core.asar.sha256
    done
  '';

  inject-tray-icon-fix = pkg:
    pkgs.symlinkJoin {
      inherit (pkg) name;
      paths = [ pkg ];
      postBuild = ''
        sed -i '2i ${fix-tray-icons} ${pkg.pname}' $out/opt/Discord/Discord
      '';
    };
in
{
  options.modules.desktop.apps.discord.enable = mkEnableOption "discord";

  config = mkIf cfg.enable {
    home.packages = [ (inject-tray-icon-fix pkgs.unstable.discord) ];
  };
}
