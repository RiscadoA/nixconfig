# overlays/overrides.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Overrides nixpkgs. Useful from getting a pkg from latest.

self: super: {
  discord = super.latest.discord.override {
    nss = super.pkgs.nss_latest;
  };
}
