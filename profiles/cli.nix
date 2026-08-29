# profiles/cli.nix
#
# "cli" profile: baseline shell tooling for every user, incl. servers.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.profiles.cli;
in
{
  options.profiles.cli.enable = mkEnableOption "cli profile";

  config = mkIf cfg.enable {
    modules = {
      xdg.enable = true;

      shell = {
        zsh.enable = true;
        git.enable = true;
        jj.enable = true;
        ssh.enable = true;
        vim.enable = true;
      };
    };

    home.packages = with pkgs; [
      htop
      ripgrep
      libqalculate
    ];
  };
}