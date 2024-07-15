# modules/home/desktop/games/vintagestory.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# vintagestory home configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  inherit (builtins) fetchurl;
  cfg = config.modules.desktop.games.vintagestory;
in
{
  options.modules.desktop.games.vintagestory.enable = mkEnableOption "vintagestory";

  config = mkIf cfg.enable {
    home.packages = [
      (pkgs.vintagestory.overrideAttrs (oldAttrs: rec {
        version = "1.19.8";
        src = fetchurl {
          url = "https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_${version}.tar.gz";
          sha256 = "sha256:08y3bxn9slrzmccymjacp53v3rqq20xqnhci4nrr6hh34q07x8j7";
        };
      }))
    ];
  };
}
