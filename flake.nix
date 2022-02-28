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
      inherit (builtins) readDir listToAttrs concatLists attrNames attrValues;
      inherit (inputs.nixpkgs) lib;
      inherit (inputs.home.nixosModules) home-manager;
      inherit (inputs.impermanence.nixosModules) impermanence;
      inherit (lib) mapAttrs removeSuffix nixosSystem;

      system = "x86_64-linux";
      user = "riscadoa";

      pkgs = mkPkgs inputs.nixpkgs [ self.overlay ];
      pkgs' = mkPkgs inputs.nixpkgs-unstable [];

      systemModules = mkModules ./modules/system;
      homeModules = mkModules ./modules/home;

      mkPkgs = pkgs: extraOverlays: import pkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = extraOverlays;
      };

      # Imports every nix module from a directory, recursively.
      mkModules = dir: concatLists (attrValues (mapAttrs
        (name: value:
          if value == "directory"
          then mkModules "${dir}/${name}"
          else if value == "regular"
          then [ (import "${dir}/${name}") ]
          else [])
        (readDir dir)));

      # Imports every host defined in a directory.
      mkHosts = dir: listToAttrs (map 
        (name: {
          inherit name;
          value = nixosSystem {
            inherit system pkgs;
            specialArgs = { inherit user; };
            modules = [
              (import "${dir}/system.nix")
              (import "${dir}/${name}/hardware.nix")
              (import "${dir}/${name}/system.nix")
              home-manager {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  sharedModules = homeModules ++ [ (import "${dir}/home.nix") ];
                  users.${user} = import "${dir}/${name}/home.nix";
                };
              }
              impermanence
            ];
          };
        })
        (attrNames (readDir dir)));      
    in {
      overlay =
        final: prev: {
          unstable = pkgs';
        };
        
      nixosConfigurations = mkHosts ./hosts;
    };
}
