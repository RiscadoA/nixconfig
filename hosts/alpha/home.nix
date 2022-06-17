# hosts/alpha/home.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Home configuration.

{ pkgs, ... }:
{
  # Modules configuration.
  modules = {
    xdg.enable = true;

    shell = {
      git.enable = true;
      gpg.enable = true;
      ssh.enable = true;
      zsh.enable = true;
      vim.enable = true;
      pass.enable = true;
    };

    desktop = {
      xmonad.enable = true;
      xmobar = {
        enable = true;
        type = "laptop";
      };

      gtk.enable = true;
      qt.enable = true;

      services = {
        picom.enable = true;
        wallpaper.enable = true;
        flameshot.enable = true;
      };      

      apps = {
        alacritty.enable = true;
        dmenu.enable = true;
        dunst.enable = true;
        discord.enable = true;
        firefox.enable = true;
        spotify.enable = true;
        vscode.enable = true;
      };

      games = {
        anki.enable = true;
        minecraft.enable = true;
      };
    };
  };

  # Extra packages.
  home.packages = with pkgs; [
    htop
    blender
    mattermost-desktop
    slack
    teams
    webots
    xournalpp
    libqalculate
    kdenlive
  ];

  # Launch applications on startup. 
  xsession.initExtra = ''
    firefox &
    discord &
    mattermost-desktop &
    spotify &
    anki &
  '';
}
