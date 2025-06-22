# modules/home/shell/pulsemixer.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# pulsemixer home configuration.

{ lib, pkgs, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.shell.pulsemixer;
in
{
  options.modules.shell.pulsemixer.enable = mkEnableOption "pulsemixer";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.pulsemixer ];

    xdg.desktopEntries.pulsemixer = {
      name = "PulseMixer";
      genericName = "PulseAudio Mixer";
      exec = "pulsemixer";
      icon = "multimedia-equalizer-symbolic";
      terminal = true;
      categories = [ "Audio" "Mixer" ];
    };
  };
}
