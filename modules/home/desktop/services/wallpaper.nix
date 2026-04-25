# modules/home/desktop/services/wallpaper.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Wallpaper service for Wayland compositors.
#
# Picks a random wallpaper from `configDir/wallpapers`, runs it through
# lutgen for Tokyo Night re-coloring, and exposes the active image at
# `~/pictures/wallpapers/current` so hyprlock and other consumers can
# point at a stable path. Re-rolls hourly.
#
# Backend autodetects from `modules.desktop.hyprland.enable`:
#   - hyprland → hyprpaper (uses hyprctl IPC for live reload)
#   - everything else (niri, sway) → swaybg (works on any wlroots compositor)
#
# Override with `backend = "hyprpaper" | "swaybg"`.
#
# Architecture (swaybg backend):
#   - swaybg.service (Type=simple): long-lived, displays ~/pictures/wallpapers/current
#   - wallpaper.service (oneshot): rolls a new image, then `systemctl restart`s swaybg
#   - wallpaper.timer: hourly trigger
# Splitting these is necessary because oneshot units kill any backgrounded
# children when they exit (cgroup teardown), so swaybg can't be launched
# from inside the roller.

{ lib, config, pkgs, configDir, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf mkMerge;
  cfg = config.modules.desktop.services.wallpaper;

  hyprlandEnabled = config.modules.desktop.hyprland.enable or false;
  backend =
    if cfg.backend == "auto"
    then (if hyprlandEnabled then "hyprpaper" else "swaybg")
    else cfg.backend;

  pictures = "${config.home.homeDirectory}/pictures/wallpapers";
  current = "${pictures}/current";

  theme = {
    name = "tokyo-night-dark";
    wallpapers = configDir + "/wallpapers";
  };

  themedWallpaper = wallpaper:
    pkgs.stdenv.mkDerivation rec {
      name = "${theme.name}-${baseNameOf wallpaper}";
      nativeBuildInputs = [ pkgs.lutgen ];
      phases = [ "buildPhase" "installPhase" ];

      buildPhase = ''
        cp ${wallpaper} ./${name}
        lutgen apply -p ${theme.name} ${name} -o themed/${name}
      '';

      installPhase = ''
        cp themed/${name} $out
      '';
    };

  wallpapers = lib.filesystem.listFilesRecursive theme.wallpapers;
  themedWallpapers = lib.listToAttrs (map (wallpaper: {
    name = "${baseNameOf wallpaper}";
    value = themedWallpaper wallpaper;
  }) wallpapers);

  wallpaperBashArray = "(\"${
    lib.strings.concatStrings (lib.strings.intersperse "\" \"" (
      map (wallpaper: "${wallpaper}") (lib.attrValues themedWallpapers)
    ))
  }\")";

  # Picks a random themed wallpaper, points ~/pictures/wallpapers/current
  # at it, then nudges the backend to display it.
  setWallpaper = pkgs.writeShellScriptBin "setWallpaper" ''
    set -eu

    mkdir -p ${pictures}

    wallpapers=${wallpaperBashArray}
    rand=$(( RANDOM % ''${#wallpapers[@]} ))
    wallpaper=''${wallpapers[$rand]}

    ln -sfn "$wallpaper" "${current}"

    ${if backend == "hyprpaper" then ''
      # Wait for hyprpaper to be ready
      for i in $(seq 1 20); do
        ${pkgs.hyprland}/bin/hyprctl hyprpaper listloaded >/dev/null 2>&1 && break
        sleep 0.25
      done

      monitors=$(${pkgs.hyprland}/bin/hyprctl monitors | ${pkgs.gnugrep}/bin/grep Monitor | ${pkgs.gawk}/bin/awk '{print $2}')
      ${pkgs.hyprland}/bin/hyprctl hyprpaper unload all
      ${pkgs.hyprland}/bin/hyprctl hyprpaper preload "$wallpaper"
      for m in $monitors; do
        ${pkgs.hyprland}/bin/hyprctl hyprpaper wallpaper "$m,$wallpaper"
      done
    '' else ''
      # Restart the long-lived swaybg.service so it picks up the new symlink
      # target. swaybg has no IPC. If swaybg.service isn't started yet
      # (first boot), `restart` will start it.
      ${pkgs.systemd}/bin/systemctl --user restart swaybg.service
    ''}
  '';
in
{
  options.modules.desktop.services.wallpaper = {
    enable = mkEnableOption "wallpaper";
    backend = mkOption {
      type = types.enum [ "auto" "hyprpaper" "swaybg" ];
      default = "auto";
      description = ''
        Wallpaper backend. `auto` picks hyprpaper when hyprland is enabled,
        swaybg otherwise.
      '';
    };
    mode = mkOption {
      type = types.enum [ "stretch" "fit" "fill" "center" "tile" "solid_color" ];
      default = "fill";
      description = "swaybg scaling mode (ignored by hyprpaper).";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = [ setWallpaper ];

      # Roll a new wallpaper. Oneshot — exits after updating the symlink
      # and (for swaybg) restarting the display service.
      systemd.user.services.wallpaper = {
        Unit = {
          Description = "Roll a random desktop wallpaper (${backend})";
          After = [ "graphical-session.target" ]
            ++ lib.optional (backend == "hyprpaper") "hyprpaper.service"
            ++ lib.optional (backend == "swaybg") "swaybg.service";
          Wants = lib.optional (backend == "swaybg") "swaybg.service";
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${setWallpaper}/bin/setWallpaper";
          IOSchedulingClass = "idle";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };

      systemd.user.timers.wallpaper = {
        Unit.Description = "Periodically re-roll the desktop wallpaper";
        Timer = {
          OnUnitActiveSec = "1h";
          Unit = "wallpaper.service";
        };
        Install.WantedBy = [ "timers.target" ];
      };
    }

    (mkIf (backend == "swaybg") {
      home.packages = [ pkgs.swaybg ];

      # Long-lived swaybg pinned to the stable symlink. Restart this unit
      # to pick up a new wallpaper (the roller above does that for us).
      # If the symlink doesn't exist yet (first start), the roller will
      # create it and restart this service.
      systemd.user.services.swaybg = {
        Unit = {
          Description = "swaybg — Wayland desktop wallpaper";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
          ConditionPathExists = current;
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.swaybg}/bin/swaybg -m ${cfg.mode} -i ${current}";
          Restart = "on-failure";
          RestartSec = 2;
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    })

    (mkIf (backend == "hyprpaper") {
      services.hyprpaper = {
        enable = true;
        settings = {
          ipc = "on";
          splash = "off";
        };
      };
    })
  ]);
}
