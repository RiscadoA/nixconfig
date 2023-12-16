# modules/home/desktop/xmobar.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# xmobar home configuration.

{ lib, config, pkgs, configDir, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.desktop.xmobar;
in {
  options.modules.desktop.xmobar = {
    enable = mkEnableOption "xmobar";
    type = mkOption {
      type = types.enum [ "laptop" "desktop" "laptop-hidpi" ];
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = [ pkgs.haskellPackages.xmobar ];
      file.".xmonad/xmobar.hs".source = "${configDir}/xmobar/${cfg.type}.hs";
    };
  };
}
