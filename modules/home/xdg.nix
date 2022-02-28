# modules/home/xdg.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# XDG home configuration.

{ ... }:
{
  config = {
    xdg = {
      enable = true;
      userDirs = {
        enable = true;
        desktop = "$HOME/desktop";
        documents = "$HOME/documents";
        download = "$HOME/downloads";
        music = "$HOME/music";
        pictures = "$HOME/pictures";
        publicShare = "$HOME/public";
        templates = "$HOME/templates";
        videos = "$HOME/videos";
        createDirectories = true;
      };
    };
  };
}
