# modules/home/desktop/apps/rofi.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# rofi home configuration.

{ lib, config, pkgs, configDir, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.apps.rofi;

  password-store-dir = config.programs.password-store.settings.PASSWORD_STORE_DIR;
  rofi-pass = pkgs.writeShellScriptBin "rofi-pass" ''
    find ${password-store-dir} -type f -name '*.gpg' |
    sed "s|${password-store-dir}/||; s|.gpg$||" |
    rofi -i -dmenu -p pass |
    xargs -n 1 pass show 2> /dev/null |
    head -n 1 |
    wl-copy --sensitive
  '';
in
{
  options.modules.desktop.apps.rofi.enable = mkEnableOption "rofi";

  config = mkIf cfg.enable {
    home.packages = [ rofi-pass ];

    programs.rofi = {
      enable = true;
      package = pkgs.rofi;
      location = "center";
      extraConfig = {
        case-sensitive = false;
      };
      theme = "${configDir}/rofi.rasi";
    };
  };
}
