# modules/home/desktop/games/steam.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# steam home configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.desktop.games.steam;
in
{
  options.modules.desktop.games.steam.enable = mkEnableOption "steam";

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs: with pkgs; [
          pkgsi686Linux.libpulseaudio
        ];
        extraArgs = "-forcedesktopscaling 1.6";
      };
    };

    services.joycond.enable = true;

    environment.systemPackages = with pkgs; [
      unstable.wineWowPackages.stable
      unstable.winetricks
    ];

    programs.gamemode.enable = true;

    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };
  };
}
