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
        type = "desktop";
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
    htop
    zip

    # Games
    anki
    minecraft

    # Other
    mattermost-desktop
    slack
    spotify
    xournalpp
  ];

  programs.browserpass.enable = true;
  programs.password-store.enable = true;

  services.flameshot.enable = true;

  home.file.".xinitrc".text = ''
    if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
      eval $(dbus-launch --exit-with-session --sh-syntax)
    fi
    systemctl --user import-environment DISPLAY XAUTHORITY

    if command -v dbus-update-activation-environment >/dev/null 2>&1; then
      dbus-update-activation-environment DISPLAY XAUTHORITY
    fi

    firefox &
    discord &
    mattermost-desktop &
    spotify &

    exec xmonad
  '';

  xsession.initExtra = ''
    firefox &
    discord &
    mattermost-desktop &
    spotify &
  '';
}
