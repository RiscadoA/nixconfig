# modules/system/wireguard.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Wireguard system configuration.

{ ... }:
{
  networking.wireguard.interfaces = {
    rnl = {
      ips = [ "192.168.20.38/24" "fd92:3315:9e43:c490::38/64" ];
      privateKeyFile = "/etc/wireguard/privkey";
      postSetup = ''
        wg set %i fwmark 765
        ip rule add not fwmark 765 table 765
        ip -6 rule add not fwmark 765 table 765
      '';
      postShutdown = ''
        ip rule del not fwmark 765 table 765
        ip -6 rule del not fwmark 765 table 765
      '';
      peers = [
        {
          publicKey = "g08PXxMmzC6HA+Jxd+hJU0zJdI6BaQJZMgUrv2FdLBY=";
          endpoint = "193.136.164.211:34266";
          allowedIPs = [ "193.136.164.0/24" "193.136.154.0/24" "10.16.64.0/18" "2001:690:2100:80::/58" "193.136.128.24/29" "146.193.33.81/32" "192.168.154.0/24" ];
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
