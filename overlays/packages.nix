# overlays/packages.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Extra packages.

self: super: rec {
  dmenu = super.dmenu.overrideAttrs (oldAttrs: rec {
    patches = [
      ../packages/dmenu/colors.patch
    ];
  });
  slock = super.slock.overrideAttrs (oldAttrs: rec {
    patches = [
      ../packages/slock/colors.patch
    ];
  });
  headsetcontrol = super.callPackage ../packages/headsetcontrol {};
}
