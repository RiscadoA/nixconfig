# modules/system/minecraft.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# minecraft server system configuration.

{ options, config, pkgs, ... }: with pkgs.lib; {
  options.services.minecraftServers = mkOption {
    type = types.listOf types.str;
    default = [];
  };

  config = {
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
      config.services.minecraftServers);
  };
}
