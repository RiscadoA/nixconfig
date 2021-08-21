# overlays/packages.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Extra packages.

self: super: rec {
  headsetcontrol = super.callPackage ../packages/headsetcontrol {};
}
