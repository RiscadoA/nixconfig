# hosts/halley/home.nix
#
# Home configuration for halley (user 'riscadoa').

{ pkgs, ... }:
{
  # Profiles shared by every user of halley (both users are developers);
  # browsers/media/games and other per-user bits live in the user files.
  profiles = {
    cli.enable = true;
    desktop.enable = true;
    development.enable = true;
  };

  modules = {
    # Host-specific tuning of the modules enabled by the profiles above.
    desktop = {
      niri.keyboardLayout = "pt";

      waybar = {
        compositor = "niri";
        compact = true;
      };

      hyprlock.suspend = true;

      services = {
        flameshot.scaleFactor = 0.5;
        low-battery-notifier.enable = true;
      };
    };
  };

  xresources.properties = {
    "Xft.dpi" = 144;
  };

  programs.readline.extraConfig = ''
    set bell-style none
  '';
}