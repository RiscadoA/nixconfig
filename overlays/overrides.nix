# overlays/overrides.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Overrides nixpkgs. Useful from getting a pkg from latest.

self: super: {
  discord = super.latest.discord;
  vscode-with-extensions = super.latest.vscode-with-extensions;
  multimc = super.latest.multimc.override { msaClientID = "3fb4be1b-44c1-414c-aef5-3ab3a642b704"; };
}
