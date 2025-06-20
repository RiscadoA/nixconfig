# modules/home/desktop/hyprpaper.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# hyprpaper home configuration.

{ lib, config, pkgs, configDir, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.hyprpaper;

  theme = {
    name = "tokyo-night-dark";
    wallpapers = configDir + "/wallpapers";
  };

  themedWallpaper = wallpaper:
    pkgs.stdenv.mkDerivation rec {
      name = "${theme.name}-${baseNameOf wallpaper}";
      nativeBuildInputs = [pkgs.lutgen];

      phases = ["buildPhase" "installPhase"];

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
    })
    wallpapers);

  wallpaperBashArray = "(\"${lib.strings.concatStrings (lib.strings.intersperse "\" \"" (map (wallpaper: "${wallpaper}") (lib.attrValues themedWallpapers)))}\")";
  wallpaperRandomizer = pkgs.writeShellScriptBin "wallpaperRandomizer" ''
    wallpapers=${wallpaperBashArray}
    rand=$[$RANDOM % ''${#wallpapers[@]}]
    wallpaper=''${wallpapers[$rand]}

    rm /home/riscadoa/pictures/wallpapers/current
    ln -s "$wallpaper" /home/riscadoa/pictures/wallpapers/current

    monitor=(`hyprctl monitors | grep Monitor | awk '{print $2}'`)
    hyprctl hyprpaper unload all
    hyprctl hyprpaper preload $wallpaper
    for m in ''${monitor[@]}; do
      hyprctl hyprpaper wallpaper "$m,$wallpaper"
    done
  '';
in
{
  options.modules.desktop.hyprpaper.enable = mkEnableOption "hyprpaper";

  config = mkIf cfg.enable {
    home.packages = [ wallpaperRandomizer ];

    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = "off";
      };
    };

    systemd.user = {
      services.wallpaperRandomizer = {
        Install = {
          WantedBy = ["graphical-session.target"];
        };

        Unit = {
          Description = "Set random desktop background using hyprpaper";
          After = ["graphical-session-pre.target"];
          PartOf = ["graphical-session.target"];
        };

        Service = {
          Type = "oneshot";
          ExecStart = "${wallpaperRandomizer}/bin/wallpaperRandomizer";
          IOSchedulingClass = "idle";
        };
      };

      timers.wallpaperRandomizer = {
        Unit = {
          Description = "Set random desktop background using hyprpaper on an interval";
        };

        Timer = {
          OnUnitActiveSec = "1h";
        };

        Install = {
          WantedBy = ["timers.target"];
        };
      };
    };
  };
}
