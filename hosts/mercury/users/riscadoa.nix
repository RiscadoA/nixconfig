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
      gpg.enable = true;
      pass.enable = true;
      taskwarrior.enable = true;
    };

    desktop = {
      xmonad.enable = true;
      xmobar = {
        enable = true;
        type = "desktop";
      };

      apps = {
        discord.enable = true;
        spotify.enable = true;
        vscode.enable = true;
      };

      games = {
        anki.enable = true;
        minecraft.enable = true;
      };
    };
  };

  # Extra packages.
  home.packages = with pkgs; [
    timewarrior
  ];

  # Syncthing for vimwiki.
  services.syncthing.enable = true;

  # Launch applications on startup. 
  xsession.initExtra = ''
    firefox &
    discord &
    spotify &
  '';
}
