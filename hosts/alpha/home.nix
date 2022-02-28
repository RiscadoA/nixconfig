# hosts/alpha/home.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Home configuration.

{ pkgs, ... }:
{
  modules = {
    xdg.enable = true;

    shell = {
      git.enable = true;
      gpg.enable = true;
      ssh.enable = true;
      zsh.enable = true;
      vim.enable = true;
    };

    desktop = {
      xmonad.enable = true;
      xmobar = {
        enable = true;
        type = "laptop";
      };

      gtk.enable = true;
      qt.enable = true;
      picom.enable = true;
      random-background.enable = true;
      
      term.alacritty.enable = true;

      apps = {
        dmenu.enable = true;
        dunst.enable = true;
        discord.enable = true;
        firefox.enable = true;
        vscode.enable = true;
      };
    };
  };

  home.packages = with pkgs; [
    # Tools
    neofetch
    playerctl
    unzip
    zip
    htop
    man-pages
    blender

    # Games
    anki-bin mpv

    # Other
    mattermost-desktop
    slack
    spotify
    webots
    xournalpp
  ];

  programs.browserpass.enable = true;
  programs.password-store.enable = true;

  services.flameshot.enable = true;

  xsession.enable = true;
  xsession.initExtra = ''
    firefox &
    discord &
    mattermost-desktop &
    spotify &
    anki &
  '';
}
