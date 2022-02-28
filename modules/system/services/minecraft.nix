# modules/system/services/minecraft.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# minecraft server system configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkMerge mkIf;
  cfg = config.modules.services.minecraft;
in {
  options.modules.services.minecraft = {
    enable = mkEnableOption "minecraft";
    syncthing.enable = mkEnableOption "syncthing";
    servers = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      users.minecraft = {
        isNormalUser = true;
        createHome = true;
        home = "/srv/minecraft";
      };

      systemd.services = builtins.listToAttrs (map
        (name: {
          name = "minecraft_${name}";
          value = {
            description = "Minecraft server ${name}";
            after = [ "fs.target" "network.target" "multi-user.target" ];
            serviceConfig = {
              Type = "forking";
              WorkingDirectory = "/srv/minecraft/${name}";
              ExecStart = "${pkgs.screen}/bin/screen -dmS minecraft_${name} ${pkgs.openjdk}/bin/java -Xmx1024M -Xms1024M -jar server.jar nogui";
              ExecStop = "${pkgs.screen}/bin/screen -p 0 -S minecraft_${name} -X 'eval stuff \\\"stop\\\"\\015'";
              User = "minecraft";
              Group = "users";  
            };
          };
        })
        cfg.minecraft.servers);
    }
    (mkIf cfg.syncthing.enable {
      services.syncthing = {
        enable = true;
        folders."Minecraft".path = "/srv/minecraft";
      };
    })
  };
}
