{ flake-inputs, ... }:

flake-inputs.nixpkgs.lib.nixosSystem {
  specialArgs = { inherit flake-inputs; };
  modules = [
   ({ config, lib, pkgs, ... }: {
      imports = [
       ./hardware.nix
       ../../shared/common.nix
       ../../shared/server
      ];

      # TODO: extract into shared/computer-id.nix

      networking.hostName = "4";

      networking.firewall = let openPorts = { from = 14000; to = 14999; }; in {
        allowedTCPPortRanges = [ openPorts ];
        allowedUDPPortRanges = [ openPorts ];
      };

      # use dhcp inform instead of static
      # to autoconfigure gateway and nameservers
      networking.dhcpcd.enable = true;
      networking.dhcpcd.extraConfig = ''
        interface enp43s0
        inform 192.168.0.104/24
      '';

      networking.interfaces.enp43s0.ipv6.addresses = [{
        address = "2804:14d:688c:40a8:7374:6174:6963:4";
        prefixLength = 64;
      }];

      # disable other ipv6 addresses
      boot.kernel.sysctl."net.ipv6.conf.enp43s0.autoconf" = 0;
   })
  ];
}

