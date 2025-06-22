# hosts/home.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
# 
# Default/common configuration for all host homes.

{ ... }:
{
  home = {
    keyboard = null;
    stateVersion = "21.11";

    shellAliases = {
      "rebuild" = "sudo nixos-rebuild switch --flake $HOME/nixos";
    };
  };

  xdg.desktopEntries = {
    nixos-option-search = {
      name = "NixOS Option Search";
      exec = "xdg-open https://search.nixos.org/options";
      icon = "distributor-logo-nixos";
      categories = [ "Documentation" ];
    };

    nixos-package-search = {
      name = "NixOS Package Search";
      exec = "xdg-open https://search.nixos.org/packages";
      icon = "distributor-logo-nixos";
      categories = [ "Documentation" ];
    };

    home-manager-option-search = {
      name = "Home Manager Option Search";
      exec = "xdg-open https://home-manager-options.extranix.com/";
      icon = "distributor-logo-nixos";
      categories = [ "Documentation" ];
    };

    github = {
      name = "GitHub";
      exec = "xdg-open https://github.com";
      icon = "github";
      categories = [ "Development" ];
    };

    cubos-repository = {
      name = "Cubos Engine Repository";
      exec = "xdg-open https://github.com/GameDevTecnico/cubos";
      icon = "github";
      categories = [ "Development" ];
    };
  };
}
