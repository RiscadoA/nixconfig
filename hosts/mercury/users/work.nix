# hosts/mercury/users/work.nix
#
# Home configuration for user 'work'.

{ pkgs, config, lib, ... }:
{
  user = {
    isNormalUser = true;
    createHome = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "projects" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDT8C1xA3eNDJ1qoEOmyIseU/n8ClLKCtGfCgD/QBYsG0BAeBqJ9t0s41vf8rBMjmZo2AfPY5os16J9Z2FOxgNKYMgPJmmnHGPzhBQ+66LDnTwDISiINqxhSh0/2EXp4YlOiSDwpbPXeqVZx2kFXAqLQgg+D+AjQAXxfrYI1JAoGUbvHCOTN5TX2rBpdgHsUGVxhsS+lHPfMTihxc1R+KSiYFGxG9l3+QfB03GQ9w5/FyGh2/HuQrNk8iTiKxIMoZTEEd1fk0iW7qqiTirOSAdaG7YkTmF6c42boZ120YhDZjMfmSMxEaptxGt8Njp3DofqDHR8Ushj7rzyr8UDS+xZ"
    ];
  };

  profiles.development.enable = true;

  home.file."projects".source = config.lib.file.mkOutOfStoreSymlink "/srv/projects";

  modules = {
    desktop.apps.spotify.enable = true;
    desktop.games.anki.enable = true;
  };

  home.packages = with pkgs; [
    blender
    vlc
    qbittorrent
  ];

  programs.git.signing.signByDefault = lib.mkForce false;
}