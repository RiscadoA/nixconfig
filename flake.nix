# flake.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# The core of my nix configuration.

{
  description = "Nix configuration for a single user system.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence/master";
    home = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, ... }:
    let
      inherit (builtins) readDir listToAttrs concatLists attrNames attrValues removeAttrs;
      inherit (inputs.nixpkgs) lib;
      inherit (inputs.home.nixosModules) home-manager;
      inherit (inputs.impermanence.nixosModules) impermanence;
      inherit (lib) mapAttrs removeSuffix hasSuffix nixosSystem;

      system = "x86_64-linux";
      user = "riscadoa";

      pkgs = mkPkgs inputs.nixpkgs [ self.overlay ];
      pkgs' = mkPkgs inputs.nixpkgs-unstable [];

      systemModules = mkModules ./modules/system;
      homeModules = mkModules ./modules/home;

      mkPkgs = pkgs: extraOverlays: import pkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = extraOverlays ++ (attrValues self.overlays);
      };

      mkOverlays = dir: listToAttrs (map
        (name: {
          name = removeSuffix ".nix" name;
          value = import "${dir}/${name}" {
            packageDir = ./packages;
          };
        })
        (attrNames (readDir dir)));

      # Imports every nix module from a directory, recursively.
      mkModules = dir: concatLists (attrValues (mapAttrs
        (name: value:
          if value == "directory"
          then mkModules "${dir}/${name}"
          else if value == "regular" && hasSuffix ".nix" name
          then [ (import "${dir}/${name}") ]
          else [])
        (readDir dir)));

      # Imports every host defined in a directory.
      mkHosts = dir: listToAttrs (map 
        (name: {
          inherit name;
          value = nixosSystem {
            inherit system pkgs;
            specialArgs = { inherit user; configDir = ./config; };
            modules = [
              (import "${dir}/system.nix")
              (import "${dir}/${name}/hardware.nix")
              (import "${dir}/${name}/system.nix")
              home-manager {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs.configDir = ./config;
                  sharedModules = homeModules ++ [ (import "${dir}/home.nix") ];
                  users.${user} = import "${dir}/${name}/home.nix";
                };
              }
              impermanence
            ] ++ systemModules;
          };
        })
        (attrNames (removeAttrs (readDir dir) [ "system.nix" "home.nix" ])));      
    in {
      overlay =
        final: prev: {
          unstable = pkgs';
        };

      overlays = mkOverlays ./overlays;

      nixosConfigurations = mkHosts ./hosts;
    };
}
