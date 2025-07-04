# hosts/mercury/users/riscadoa.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Home configuration for user 'riscadoa'.

{ pkgs, ... }:
{
  user = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "steam" "wheel" "libvirtd" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDT8C1xA3eNDJ1qoEOmyIseU/n8ClLKCtGfCgD/QBYsG0BAeBqJ9t0s41vf8rBMjmZo2AfPY5os16J9Z2FOxgNKYMgPJmmnHGPzhBQ+66LDnTwDISiINqxhSh0/2EXp4YlOiSDwpbPXeqVZx2kFXAqLQgg+D+AjQAXxfrYI1JAoGUbvHCOTN5TX2rBpdgHsUGVxhsS+lHPfMTihxc1R+KSiYFGxG9l3+QfB03GQ9w5/FyGh2/HuQrNk8iTiKxIMoZTEEd1fk0iW7qqiTirOSAdaG7YkTmF6c42boZ120YhDZjMfmSMxEaptxGt8Njp3DofqDHR8Ushj7rzyr8UDS+xZ (none)"
    ];
  };

  # Modules configuration.
  modules = {
    shell = {
      gdb.enable = true;
      gpg.enable = true;
      pass.enable = true;
    };

    desktop = {
      apps = {
        discord.enable = true;
        spotify.enable = true;
      };

      games = {
        anki.enable = true;
      };
    };
  };

  # Extra packages.
  home.packages = with pkgs; [
    timewarrior
    renderdoc
    openmsx
  ];

  services.syncthing.enable = true;

  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "[workspace 1 silent] kitty"
      "[workspace 3 silent] firefox"
      "[workspace 4 silent] discord"
      "[workspace 6 silent] spotify"
    ];
  };
}
