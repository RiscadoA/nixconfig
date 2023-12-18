# overlays/packages.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Extra packages.

{ packageDir, ... }: final: prev: rec {
  dmenu = prev.dmenu.overrideAttrs (oldAttrs: rec {
    patches = [
      "${packageDir}/dmenu/colors.patch"
    ];
  });

  slock = prev.slock.overrideAttrs (oldAttrs: rec {
    patches = [
      "${packageDir}/slock/colors.patch"
    ];
  });

  headsetcontrol = prev.callPackage "${packageDir}/headsetcontrol" { };
}
