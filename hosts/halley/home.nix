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
      xmonad.enable = true;
      xmobar = {
        enable = true;
        type = "laptop-hidpi";
      };

      gtk.enable = true;
      qt.enable = true;

      services = {
        picom.enable = true;
        wallpaper.enable = true;
        flameshot.enable = true;
        low-battery-notifier.enable = true;
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
  ];

  programs.readline.extraConfig = ''
    set bell-style none
  '';

  services.syncthing.enable = true;
}
