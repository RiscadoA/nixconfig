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
  options.modules.desktop.games.steam = {
    enable = mkEnableOption "steam";
    desktopScaling = mkOption {
      type = types.float;
      default = 1.0;
      description = "Desktop scaling factor for Steam. This is useful for high DPI displays.";
      example = 1.6;
    };
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs: with pkgs; [
          pkgsi686Linux.libpulseaudio
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
        ];
        extraArgs = "-forcedesktopscaling ${toString cfg.desktopScaling}";
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
      # https://github.com/NixOS/nixpkgs/issues/351516
      # capSysNice = true;
    };
  };
}
