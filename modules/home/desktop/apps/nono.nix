# modules/home/desktop/apps/nono.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# nono (nono.sh) home configuration: OS-level sandboxing for coding agents.

{ lib, config, pkgs, configDir, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.modules.desktop.apps.nono;
  jsonFormat = pkgs.formats.json { };
  baseProfile = builtins.fromJSON (builtins.readFile (configDir + "/nono/pi.json"));

  # Merge a profile section into the base one. List values are appended (so
  # extra filesystem grants do not drop the base ones), other values override.
  mergeSection = base: extra:
    lib.recursiveUpdate base (lib.mapAttrs (name: value:
      if builtins.isList value then (base.${name} or [ ]) ++ value else value)
      extra);

  profile =
    baseProfile
    // (if cfg.piProfile.name != "pi" then
      {
        meta = baseProfile.meta // { name = cfg.piProfile.name; };
      }
    else
      { })
    // cfg.piProfile.extra
    // (if cfg.piProfile.envCredentials != { } then
      {
        env_credentials = baseProfile.env_credentials or { } // cfg.piProfile.envCredentials;
      }
    else
      { })
    // (if cfg.piProfile.filesystem != { } then
      {
        filesystem = mergeSection baseProfile.filesystem cfg.piProfile.filesystem;
      }
    else
      { });
in
{
  options.modules.desktop.apps.nono = {
    enable = mkEnableOption "nono";

    piProfile = {
      enable = mkEnableOption "pi sandbox integration";

      name = mkOption {
        type = types.str;
        default = "pi";
        description = "Name of the nono profile used to sandbox pi.";
      };

      envCredentials = mkOption {
        type = types.attrsOf types.str;
        default = {
          OPENCODE_API_KEY = "OPENCODE_API_KEY";
        };
        example = {
          OPENCODE_API_KEY = "OPENCODE_API_KEY";
        };
        description = ''
          Environment variables nono injects into the sandbox from the system
          keychain. Keys are keychain account names, values are the environment
          variables pi reads. The default covers the opencode-go provider, which
          pi authenticates with the OPENCODE_API_KEY environment variable.

          Store each key in the nono keychain under the account name:

            secret-tool store --label="nono: OPENCODE_API_KEY" \
              service nono username OPENCODE_API_KEY target default

          Note: this injects the real key into the sandbox environment. Pi reads
          its provider keys from the environment, so a phantom-proxy route (which
          would keep the key out of the sandbox) does not apply to opencode-go:
          pi hardcodes the provider base URLs and opencode-go spans two API
          families with different auth headers.
        '';
      };

      filesystem = mkOption {
        type = types.attrs;
        default = { };
        description = "Extra filesystem grants merged into the profile.";
      };

      extra = mkOption {
        type = types.attrs;
        default = { };
        description = "Extra settings merged into the top level of the profile.";
      };

      launchThroughNono = mkOption {
        type = types.bool;
        default = true;
        description = "Alias the pi command to run inside the nono sandbox.";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.unstable.nono ];

    home.file = mkIf cfg.piProfile.enable {
      ".config/nono/profiles/${cfg.piProfile.name}.json".source =
        jsonFormat.generate "nono-${cfg.piProfile.name}.json" profile;
    };

    home.shellAliases = mkIf (cfg.piProfile.enable && cfg.piProfile.launchThroughNono) {
      pi = "nono run --profile ${cfg.piProfile.name} --allow-cwd -- pi";
    };
  };
}
