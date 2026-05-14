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
      (pkgs.symlinkJoin {
        name = "vintagestory";
        paths = [ pkgs.unstable.vintagestory ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/vintagestory \
            --set __NV_PRIME_RENDER_OFFLOAD 1 \
            --set __NV_PRIME_RENDER_OFFLOAD_PROVIDER NVIDIA-G0 \
            --set __GLX_VENDOR_LIBRARY_NAME nvidia \
            --set __VK_LAYER_NV_optimus NVIDIA_only
        '';
      })
    ];
  };
}
