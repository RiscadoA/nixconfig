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

  haskellPackages = prev.haskellPackages.override {
    overrides = self: super: {
      xmonad-contrib = super.xmonad-contrib_0_18_1;
    };
  };

  wl-clipboard = prev.wl-clipboard.overrideAttrs (oldAttrs: {
    src = oldAttrs.src.override {
      rev = "aaa927ee7f7d91bcc25a3b68f60d01005d3b0f7f";
      hash = "sha256-V8JAai4gZ1nzia4kmQVeBwidQ+Sx5A5on3SJGSevrUU=";
    };
  });

  gamescope = prev.gamescope.overrideAttrs (oldAttrs: {
    patches = oldAttrs.patches ++ [
      (final.fetchpatch {
        url = "https://patch-diff.githubusercontent.com/raw/ValveSoftware/gamescope/pull/1867.patch";
        hash = "sha256-+Is4HOGAXS9q2L7s/D+9J5BpKYK6Tiho5xzTAEJGUWA=";
      })
    ];
  });
}
