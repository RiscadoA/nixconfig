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
      pulsemixer.enable = true;
      direnv.enable = true;
    };

    desktop = {
      hyprland.enable = true;
      hyprpaper.enable = true;
      hyprlock.enable = true;
      waybar = {
        enable = true;
        sizeMultiplier = 1.2;
      };
      gtk.enable = true;
      qt.enable = true;

      services = {
        flameshot = {
          enable = true;
          wayland = true;
        };
      };

      apps = {
        rofi.enable = true;
        mako.enable = true;
        kitty.enable = true;
        firefox.enable = true;
        dolphin.enable = true;
        vscode.enable = true;
      };

      games = {
        minecraft.enable = true;
      };
    };
  };

  wayland.windowManager.hyprland.settings.input = {
    kb_layout = "us";
    kb_variant = "altgr-intl";
    kb_options = "compose:ralt nodeadkeys";
  };

  # Extra packages.
  home.packages = with pkgs; [
    htop
    blender
    xournalpp
    libqalculate
    kdePackages.kdenlive
    freecad
    ckan
    lutris
    vlc
    qbittorrent
    ripgrep
    obsidian
    gemini-cli
  ];
}
