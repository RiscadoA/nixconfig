# hosts/mercury/home.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Home configuration common to all users.

{ pkgs, ... }:
{
  # Modules configuration.
  modules = {
    xdg.enable = true;

    shell = {
      lf.enable = true;
      git.enable = true;
      ssh.enable = true;
      zsh.enable = true;
      vim.enable = true;
    };

    desktop = {
      xscreensaver.enable = true;
      gtk.enable = true;
      qt.enable = true;

      services = {
        picom.enable = true;
        wallpaper.enable = true;
        flameshot.enable = true;
      };      

      apps = {
        alacritty = {
          enable = true;
          fontSize = 12;
        };
        dmenu.enable = true;
        dunst.enable = true;
        firefox.enable = true;
      };
    };
  };

  # Extra packages.
  home.packages = with pkgs; [
    htop
    blender
    xournalpp
    libqalculate
    kdenlive
    freecad
    ckan
    lutris
    vlc
    qbittorrent
    ripgrep
    unstable.obsidian
  ];
}
