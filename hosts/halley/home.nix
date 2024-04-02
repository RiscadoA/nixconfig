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
        minecraft.enable = true;
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
    unstable.obsidian
    (vintagestory.overrideAttrs (oldAttrs: rec {
      version = "1.19.7";
      src = fetchurl {
        url = "https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_${version}.tar.gz";
        sha256 = "sha256-C+vPsoMlo6EKmzf+XkvIhrDGG7EccU8c36GZt0/1r1Q=";
      };
    }))
  ];

  services.syncthing.enable = true;
}
