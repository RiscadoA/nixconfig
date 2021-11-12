# flake.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# The core of my nix configuration. A good starting point.

{
  description = "Nix configuration for a single user system.";

  inputs = {
    nixpkgs      = { url = "github:nixos/nixpkgs/nixos-21.05"; };
    unstable     = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    latest       = { url = "github:nixos/nixpkgs/master"; };
    impermanence = { url = "github:nix-community/impermanence/master"; };
    home         = {
      url = "github:nix-community/home-manager/release-21.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, ... }:
    let
      inherit (builtins) listToAttrs attrValues attrNames readDir;
      inherit (inputs.nixpkgs) lib;
      inherit (lib) removeSuffix;

      system = "x86_64-linux";
      user = "riscadoa";

      pkgs = (import inputs.nixpkgs) {
        inherit system;
        config.allowUnfree = true;
        overlays = attrValues self.overlays;
      };

      mkOverlays = dir: listToAttrs (map
        (name: {
          name = removeSuffix ".nix" name;
          value = import (dir + "/${name}");
        })
        (attrNames (readDir dir)));

      mkHosts = dir: listToAttrs (map
        (name: {
          inherit name;
          value = inputs.nixpkgs.lib.nixosSystem {
            inherit system pkgs;
            modules = [
              dir
              (dir + "/${name}/configuration.nix")
              inputs.home.nixosModules.home-manager {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${user} = import (dir + "/${name}/home.nix");
              }
	            inputs.impermanence.nixosModules.impermanence
            ]; 
          };
       })
       (attrNames (readDir dir)));

    in {

      overlays = mkOverlays ./overlays // {
        unstable = final: prev: {
          unstable = import inputs.unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };
        latest = final: prev: {
          latest = import inputs.latest {
            inherit system;
            config.allowUnfree = true;
          };
        };
      };

      nixosConfigurations = mkHosts ./hosts;
    };
}
