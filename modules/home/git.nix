# modules/home/git.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Git home configuration.

{ ... }:
{
  programs.git.enable = true;
  programs.git.userName = "Ricardo Antunes";
  programs.git.userEmail = "me@riscadoa.com";
  programs.git.signing = {
    key = null;
    signByDefault = true;
  };
  programs.git.extraConfig = {
    init.defaultBranch = "main";
    url."git@github.com".pushinsteadOf = "https://github.com/";
  };
}
