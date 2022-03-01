# hosts/system.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
# 
# Default/common configuration for all host systems.

{ inputs, pkgs, lib, ... }:
let
  inherit (builtins) toString;
  inherit (lib.my) mapModules;
in
{
  nix.package = pkgs.nixUnstable;
  nix.extraOptions = "experimental-features = nix-command flakes";

  # Every host shares the same time zone.
  time.timeZone = "Europe/Lisbon";

  # Essential packages.
  environment.systemPackages = with pkgs; [
    cached-nix-shell
    git
    vim
    wget
    gnumake
    zip
    unzip
    neofetch
    man-pages
  ];

  system.stateVersion = "21.11";
}
