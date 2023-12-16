# modules/system/desktop/fonts.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# fonts configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.fonts;
in {
  options.modules.desktop.fonts.enable = mkEnableOption "fonts";

  config = mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        noto-fonts 
        noto-fonts-cjk
        font-awesome
      ];

      fontconfig.defaultFonts = {
        serif = [ "Noto Serif" "Noto Sans CJK JP" ];
        sansSerif = [ "Noto Sans Serif" "Noto Sans CJK JP" ];
        monospace = [ "Noto Sans Mono" "Noto Sans Mono CJK JP" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
