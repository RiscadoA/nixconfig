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

  firefly-iii-data-importer = prev.firefly-iii-data-importer.overrideAttrs (oldAttrs: rec {
    version = "2.1.0";
    src = oldAttrs.src.override {
      tag = "v${version}";
      hash = "sha256-b5aOhTqYZqjdNl3WD69+EwqP/6u0t2FI3OgdZ2x5Suk=";
    };
    npmDeps = final.fetchNpmDeps {
      inherit src;
      name = "${oldAttrs.pname}-npm-deps";
      hash = "sha256-5HUCF9LrQFFBLMcDx0h2DtRxO8pGMzR/WK11AeyrWRM=";
    };
    vendorHash = "sha256-7dKpBlpAcg3E3QrdEgrc3//73MWjlrw0PyISV/BriYQ=";
    composerRepository = final.php84.mkComposerRepository {
      inherit (oldAttrs) pname;
      inherit src vendorHash version;
      composerNoDev = true;
      composerNoPlugins = true;
      composerNoScripts = true;
      composerStrictValidation = true;
    };
  });
}
