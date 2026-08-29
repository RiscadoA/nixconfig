# profiles/development.nix
#
# "development" profile: the work toolchain (editors, coding agents,
# debugging).

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.profiles.development;
in
{
  options.profiles.development.enable = mkEnableOption "development profile";

  config = mkIf cfg.enable {
    modules = {
      desktop.apps = {
        vscode.enable = true;
        zed.enable = true;
        opencode.enable = true;
        pi.enable = true;
        nono = {
          enable = true;
          piProfile.enable = true;
        };
      };

      shell.gdb.enable = true;
    };

    home.packages = with pkgs; [
      renderdoc
      gemini-cli
    ];
  };
}