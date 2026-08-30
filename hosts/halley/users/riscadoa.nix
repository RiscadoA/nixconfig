# hosts/halley/users/riscadoa.nix
#
# Home configuration for user 'riscadoa'.

{ pkgs, config, ... }:
{
  user = {
    isNormalUser = true;
    createHome = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "video" "libvirtd" "docker" "networkmanager" "gamemode" ];
  };

  modules = {
    desktop = {
      apps = {
        obsidian = {
          enable = true;
          personalVault = "/home/riscadoa/documents/Personal Notes";
          sharedVault = "/home/riscadoa/documents/Shared Notes";
        };
        firefox.enable = true;
        discord.enable = true;
        spotify.enable = true;
      };

      games = {
        anki.enable = true;
        minecraft.enable = true;
        vintagestory.enable = true;
      };

      waybar.gmail = true;
    };

    shell = {
      gpg.enable = true;
      pass.enable = true;
    };
  };

  home.packages = with pkgs; [
    blender
    vlc
    qbittorrent
    imv
    the-powder-toy
    gnome-network-displays
    godot_4
    gimp
    goxel
    czkawka-full
    zathura
    signal-desktop
    xournalpp
    timewarrior
  ];

  services.syncthing.enable = true;
}