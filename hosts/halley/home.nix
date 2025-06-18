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
    };

    desktop = {
      hyprland.enable = true;
      waybar.enable = true;
      rofi.enable = true;
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
  ];

  xresources.properties = {
    "Xft.dpi" = 144;
  };

  programs.readline.extraConfig = ''
    set bell-style none
  '';

  services.syncthing.enable = true;

  xdg.desktopEntries = {
    pulsemixer = {
      name = "PulseMixer";
      genericName = "PulseAudio Mixer";
      exec = "pulsemixer";
      icon = "multimedia-equalizer-symbolic";
      terminal = true;
      categories = [ "Audio" "Mixer" ];
    };
  };
}
