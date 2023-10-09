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
      lf.enable = true;
      git.enable = true;
      gpg.enable = true;
      ssh.enable = true;
      zsh.enable = true;
      vim.enable = true;
      pass.enable = true;
      taskwarrior.enable = true;
      direnv.enable = true;
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
    slack
    xournalpp
    libqalculate
    timewarrior
    ripgrep
  ];

  # Syncthing for vimwiki.
  services.syncthing.enable = true;

  # Launch applications on startup. 
  xsession.initExtra = ''
    firefox &
    discord &
    spotify &
    anki &
  '';
}
