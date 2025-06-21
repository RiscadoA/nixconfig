# hosts/mercury/users/guest.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Home configuration for user 'guest'.

{ pkgs, configDir, ... }:
{
  user = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "steam" "nopasswdlogin" "libvirtd" ];
  };

  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "[workspace 1 silent] kitty --title Keybinds -e less +0 ${configDir + "/keybinds.txt"}"
    ];
    windowrule = [
      "float, title:^(Keybinds)$"
      "center, title:^(Keybinds)$"
    ];
  };
}
