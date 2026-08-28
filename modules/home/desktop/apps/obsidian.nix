# modules/home/desktop/apps/obsidian.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Obsidian home configuration. Installs obsidian and adds desktop entries
# that open the personal and shared vaults directly, skipping Obsidian's
# vault switcher.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkMerge mkOption types;
  cfg = config.modules.desktop.apps.obsidian;

  # The obsidian binary accepts an `obsidian://` URI as its first argument
  # (see the packaged obsidian.desktop: `Exec=obsidian %u`). Opening by
  # absolute `path` does not require the vault to be registered in Obsidian's
  # vault list: it resolves to whichever vault contains that path.
  vaultUri = path: "obsidian://open?path=${path}";

  vaultEntry = name: comment: path: {
    name = name;
    comment = comment;
    icon = "obsidian";
    exec = "${pkgs.obsidian}/bin/obsidian \"${vaultUri path}\"";
    categories = [ "Office" ];
  };
in
{
  options.modules.desktop.apps.obsidian = {
    enable = mkEnableOption "obsidian";

    personalVault = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Absolute path to the personal Obsidian vault. Adds a "Personal Notes"
        desktop entry. Leave unset if the vault is not exposed on this host.
      '';
      example = "/home/riscadoa/Documents/notes";
    };

    sharedVault = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Absolute path to the shared Obsidian vault. Adds a "Shared Notes"
        desktop entry. Leave unset if the vault is not exposed on this host.
      '';
      example = "/home/riscadoa/shared";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.obsidian ];

    # Route obsidian:// links (e.g. from the web clipper or other apps) to
    # Obsidian through xdg-open. Requires xdg.enable = true in the host.
    xdg.mimeApps = {
      enable = true;
      defaultApplications."x-scheme-handler/obsidian" = "obsidian.desktop";
    };

    # Desktop entries, searchable from the launcher (fuzzel/rofi drun).
    xdg.desktopEntries = mkMerge [
      (mkIf (cfg.personalVault != null) {
        obsidian-personal = vaultEntry "Personal Notes" "Open the personal Obsidian vault" cfg.personalVault;
      })
      (mkIf (cfg.sharedVault != null) {
        obsidian-shared = vaultEntry "Shared Notes" "Open the shared Obsidian vault" cfg.sharedVault;
      })
    ];
  };
}