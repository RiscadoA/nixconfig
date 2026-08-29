# modules/system/services/projects.nix
#
# Shared projects directory (setgid group), symlinked into user homes as
# ~/projects.
#
# Setgid keeps the shared group on everything created inside; a default ACL
# gives members rwx on new files too (the kernel ignores the umask for file
# creation when a default ACL is present), so the dir behaves like a normal
# shared folder for group members.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.services.projects;
in
{
  options.modules.services.projects = {
    enable = mkEnableOption "shared projects directory";

    dir = mkOption {
      type = types.str;
      default = "/srv/projects";
      description = "Absolute path of the shared projects directory.";
    };

    group = mkOption {
      type = types.str;
      default = "projects";
      description = "Group that owns the shared projects directory.";
    };
  };

  config = mkIf cfg.enable {
    users.groups.${cfg.group} = { };

    # Create the directory at switch time (not only at boot via tmpfiles).
    # The setgid bit (2/2755) + default ACL make it behave like a normal
    # shared dir for group members.
    system.activationScripts.projects-dir = lib.stringAfter [ "users" ] ''
      mkdir -p ${cfg.dir}
      chmod 2775 ${cfg.dir}
      chown root:${cfg.group} ${cfg.dir}
      ${pkgs.acl}/bin/setfacl -m g::rwx -d -m g::rwx ${cfg.dir}
    '';
  };
}