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

  # niri-session calls `systemctl --user import-environment` without variable
  # names, which systemd reports as deprecated on the TTY before niri maps the
  # display. Spell the names out to silence the warning (matches the upstream
  # fix in niri PR #3572 / #4025).
  niri = prev.niri.overrideAttrs (oldAttrs: {
    postInstall = (oldAttrs.postInstall or "") + ''
      sed -i 's/systemctl --user import-environment$/systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP/' \
        $out/bin/niri-session
    '';
  });
}
