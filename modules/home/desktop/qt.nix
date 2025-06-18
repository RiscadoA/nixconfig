# modules/home/desktop/qt.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Qt home configuration.

{ lib, pkgs, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.qt;

  tokyonight-kvantum = pkgs.fetchFromGitHub {
    owner = "0xsch1zo";
    repo = "Kvantum-Tokyo-Night";
    rev = "82d104e0047fa7d2b777d2d05c3f22722419b9ee";
    sha256 = "sha256-Uy/WthoQrDnEtrECe35oHCmszhWg38fmDP8fdoXQgTk=";
  };
in
{
  options.modules.desktop.qt.enable = mkEnableOption "qt";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      libsForQt5.qtstyleplugin-kvantum
      libsForQt5.qt5ct
    ];

    home.file.".config/Kvantum/Kvantum-Tokyo-Night" = {
      source = "${tokyonight-kvantum}/Kvantum-Tokyo-Night";
      recursive = true;
    };

    home.file.".config/Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Kvantum-Tokyo-Night
    '';

    qt = {
      enable = true;
      platformTheme.name = "qt5ct";
      style.name = "kvantum";
    };
  };
}
