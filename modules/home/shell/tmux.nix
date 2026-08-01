# modules/home/shell/tmux.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# tmux home configuration.
#
# Used for persistent remote pi sessions: run pi inside a tmux session on
# mercury, then SSH in from any device (e.g. Termux on a phone) and reattach.
# The session (and the agent running inside it) survives SSH disconnects.

{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.shell.tmux;
in
{
  options.modules.shell.tmux = {
    enable = mkEnableOption "tmux";

    enableExtendedKeys = mkEnableOption ''
      tmux extended-keys forwarding (CSI-u) so pi can distinguish Shift+Enter
      and Ctrl+Enter from plain Enter
    '';
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      extraConfig = lib.mkIf cfg.enableExtendedKeys ''
        # Forward modified keys in CSI-u format (tmux >= 3.5). Without this,
        # tmux collapses Shift+Enter/Ctrl+Enter into plain Enter and pi's
        # keybindings for those chords stop working.
        set -g extended-keys on
        set -g extended-keys-format csi-u
      '';
    };
  };
}
