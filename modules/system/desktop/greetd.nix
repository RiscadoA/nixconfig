# modules/system/desktop/greetd.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# greetd system configuration.

{ lib, pkgs, config, configDir, ... }:

let
  inherit (builtins) length head;
  inherit (lib) mkEnableOption mkOption types mkIf mkMerge;
  cfg = config.modules.desktop.greetd;

  wallpaper = configDir + "/wallpapers/tokyo_night.png";
  theme = "tokyo-night-dark";
  
  themedWallpaper = pkgs.stdenv.mkDerivation rec {
    name = "${theme}-${baseNameOf wallpaper}";
    nativeBuildInputs = [pkgs.lutgen];

    phases = ["buildPhase" "installPhase"];

    buildPhase = ''
      cp ${wallpaper} ./${name}
      lutgen apply -p ${theme} ${name} -o themed/${name}
    '';

    installPhase = ''
      cp themed/${name} $out
    '';
  };
in
{
  options.modules.desktop.greetd.enable = mkEnableOption "greetd";

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
    };

    programs.regreet = {
      enable = true;
      theme = {
        package = pkgs.tokyonight-gtk-theme;
        name = "Tokyonight-Dark"; 
      };
      font = {
        package = pkgs.noto-fonts;
        name = "Noto Sans Mono";
      };
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
      cursorTheme = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Original-Classic";
      };
      settings = {
        background = {
          path = "${themedWallpaper}";
        };
      };
    };
  };
}
