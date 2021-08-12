# modules/home/xdg.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# XDG home configuration.

{ ... }:
{
  xdg.enable = true;
  xdg.userDirs.enable = true;
  xdg.userDirs.desktop = "$HOME/desktop";
  xdg.userDirs.documents = "$HOME/documents";
  xdg.userDirs.download = "$HOME/downloads";
  xdg.userDirs.music = "$HOME/music";
  xdg.userDirs.pictures = "$HOME/pictures";
  xdg.userDirs.publicShare = "$HOME/public";
  xdg.userDirs.templates = "$HOME/templates";
  xdg.userDirs.videos = "$HOME/videos";
  xdg.userDirs.createDirectories = true;
}
