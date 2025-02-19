{ pkgs, ... }:
{
  user = {
    isNormalUser = true;
    createHome = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "video" "libvirtd" "docker" "networkmanager" "gamemode" ];
  };
}
