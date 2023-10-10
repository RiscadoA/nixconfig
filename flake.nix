# flake.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# The core of my nix configuration.

{
  description = "Nix configuration for a multi user system.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence/master";
    home = {
      url = "github:nix-community/home-manager/release-23.05";
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

      pkgs = mkPkgs inputs.nixpkgs [ self.overlays.default ];
      pkgs' = mkPkgs inputs.nixpkgs-unstable [];

      systemModules = mkModules ./modules/system;
      homeModules = mkModules ./modules/home;

      mkPkgs = pkgs: extraOverlays: import pkgs {
        inherit system;
        config.allowUnfree = true;
        config.permittedInsecurePackages = [ "openssl-1.1.1w" ];
        overlays = extraOverlays ++ (attrValues self.overlays);
      };

      mkOverlays = dir: listToAttrs (map
        (name: {
          name = removeSuffix ".nix" name;
          value = import "${dir}/${name}" {
            packageDir = ./packages;
          };
        })
        (attrNames (readDir dir)) ++ [{
          name = "default";
          value = final: prev: {
            unstable = pkgs';
          };
        }]);

      # Imports every nix module from a directory, recursively.
      mkModules = dir: concatLists (attrValues (mapAttrs
        (name: value:
          if value == "directory"
          then mkModules "${dir}/${name}"
          else if value == "regular" && hasSuffix ".nix" name
          then [ (import "${dir}/${name}") ]
          else [])
        (readDir dir)));

      # Imports every user defined in a host directory.
      mkUsers = dir: map
        (name: {
          name = removeSuffix ".nix" name;
          value = import "${dir}/${name}";
        })
        (attrNames (readDir dir));

      # Imports every host defined in a directory.
      mkHosts = dir: listToAttrs (map 
        (name: {
          inherit name;
          value = nixosSystem {
            inherit system pkgs;
            specialArgs = { configDir = ./config; };
            modules =
              let
                users = mkUsers "${dir}/${name}/users"; 
              in [
                { networking.hostName = name; }
                (import "${dir}/system.nix")
                (import "${dir}/${name}/hardware.nix")
                (import "${dir}/${name}/system.nix")
                home-manager {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    extraSpecialArgs.configDir = ./config;
                    sharedModules = homeModules ++ [
                      (import "${dir}/home.nix")
                      (import "${dir}/${name}/home.nix")
                    ];
                    users = listToAttrs (map
                      (user: {
                        name = user.name;
                        value = args @ { pkgs, ... }: removeAttrs (user.value args) [ "user" ];
                      })
                      users);
                  };
                }
                impermanence
              ] ++ systemModules
                ++ (map (user: args @ { pkgs, ... }: {
                    users.users.${user.name} = (user.value args).user;
                  }) users);
          };
        })
        (attrNames (removeAttrs (readDir dir) [ "system.nix" "home.nix" ])));      
    in {
      overlays = mkOverlays ./overlays;
      nixosConfigurations = mkHosts ./hosts;
    };
}
