{ pkgs, ... }:
{
  modules = {
    xdg.enable = true;

    shell = {
      lf.enable = true;
      git.enable = true;
      gdb.enable = true;
      gpg.enable = true;
      ssh.enable = true;
      zsh.enable = true;
      vim.enable = true;
      pass.enable = true;
      direnv.enable = true;
      pulsemixer.enable = true;
    };

    desktop = {
      hyprland.enable = true;
      hyprpaper.enable = true;
      hyprlock.enable = true;
      hyprsunset.enable = true;
      waybar = {
        enable = true;
        compact = true;
      };
      gtk.enable = true;
      qt.enable = true;

      services = {
        flameshot = {
          enable = true;
          wayland = true;
          scaleFactor = 0.5;
        };
        low-battery-notifier.enable = true;
      };

      apps = {
        kitty.enable = true;
        rofi.enable = true;
        mako.enable = true;
        discord.enable = true;
        firefox.enable = true;
        spotify.enable = true;
        vscode.enable = true;
        dolphin.enable = true;
      };

      games = {
        anki.enable = true;
        minecraft.enable = true;
        vintagestory.enable = true;
      };
    };
  };

  wayland.windowManager.hyprland.settings.input = {
    kb_layout = "pt";
  };

  home.packages = with pkgs; [
    htop
    blender
    xournalpp
    libqalculate
    timewarrior
    ripgrep
    obsidian
    renderdoc
    godot_4
    qbittorrent
    vlc
    lutris
    goxel
    czkawka-full
    gimp
    zathura
    imv
    the-powder-toy
    gnome-network-displays
  ];

  xresources.properties = {
    "Xft.dpi" = 144;
  };

  programs.readline.extraConfig = ''
    set bell-style none
  '';

  services.syncthing.enable = true;
}
