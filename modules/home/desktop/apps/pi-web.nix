# modules/home/desktop/apps/pi-web.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# pi-web home configuration.
#
# pi-web is a web UI for Pi Coding Agent that runs persistent agent sessions
# in real workspaces (git worktrees, terminals, files) and supervises them
# from any browser. Two per-user services are used:
#
#   pi-web-sessiond  long-lived session daemon that owns/spawns agent sessions
#   pi-web-server    web/API gateway
#
# The system `pi` binary is only used by pi-web for `pi install/remove/update`
# package management; agent sessions run in-process via the embedded
# @earendil-works/pi-coding-agent library (0.82.x), so the system pi version
# does not gate session functionality.
#
# Declarative configuration is injected through environment variables instead
# of a generated config file:
#   - pi-web rewrites ~/.config/pi-web/config.json on every startup
#     (normalization) and the browser Settings UI persists to it, so a
#     Nix-managed copy would be clobbered or would clobber UI changes.
#   - Environment overrides take precedence over the config file
#     (defaults -> config file -> environment), so our host/port/session
#     settings always win while browser-side settings (keyboards shortcuts,
#     plugins, machines, pathAccess, ...) persist in the config file and are
#     never reset on switch.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types boolToString;
  cfg = config.modules.desktop.apps.pi-web;
in
{
  options.modules.desktop.apps.pi-web = {
    enable = mkEnableOption "pi-web";

    host = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = ''
        Address the web/API service binds to. Use the machine's Tailscale IP
        when exposing pi-web through the pluto nginx proxy over Tailscale.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 8504;
      description = "Port the web/API service listens on.";
    };

    spawnSessions = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Allow LLMs to start new sessions via the spawn_session tool. Requires
        projects to be registered (workspaces are resolved from project cwds).
      '';
    };

    askUser = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Present agent asks to the user instead of letting the agent run free.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.pi-web ];

    systemd.user.services = {
      pi-web-sessiond = {
        Unit = {
          Description = "PI WEB session daemon";
          After = [ "network.target" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.pi-web}/bin/pi-web-sessiond";
          Environment = [
            "PI_WEB_SPAWN_SESSIONS=${boolToString cfg.spawnSessions}"
            "PI_WEB_ASK_USER=${boolToString cfg.askUser}"
          ];
          Restart = "on-failure";
          RestartSec = 2;
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };

      pi-web-server = {
        Unit = {
          Description = "PI WEB server";
          After = [ "network.target" "pi-web-sessiond.service" ];
          Wants = [ "pi-web-sessiond.service" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.pi-web}/bin/pi-web-server";
          Environment = [
            "PI_WEB_HOST=${cfg.host}"
            "PI_WEB_PORT=${toString cfg.port}"
          ];
          Restart = "on-failure";
          RestartSec = 2;
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    };
  };
}
