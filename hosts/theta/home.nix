# hosts/alpha/home.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Home configuration.

{ pkgs, ... }:
{
  imports = [
    ../../modules/home/git.nix
    ../../modules/home/ssh.nix
    ../../modules/home/zsh.nix
    ../../modules/home/gnupg.nix
    ../../modules/home/vim.nix
    ../../modules/home/xdg.nix
    
    # Graphical
    ../../modules/home/picom.nix
    ../../modules/home/random-background.nix
    ../../modules/home/xmonad.nix
    ../../modules/home/xmobar.nix
    ../../modules/home/dmenu.nix
    ../../modules/home/dunst.nix
    ../../modules/home/qt.nix
    ../../modules/home/gtk.nix
    ../../modules/home/alacritty.nix
    ../../modules/home/firefox.nix
    ../../modules/home/vscode.nix
  ];

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
    discord
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

  home.keyboard = null;

  home.stateVersion = "21.05";
}
