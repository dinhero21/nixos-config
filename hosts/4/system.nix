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

      # TODO: extract into shared/minecraft-server.nix

      systemd.sockets.minecraft-server-al-stdin = {
        unitConfig = {
          BindsTo = ["minecraft-server-al.service"];
        };
        socketConfig = {
          Service = "minecraft-server-al.service";
          ListenFIFO = "/run/minecraft-server-al-stdin";
          RemoveOnStop = true;
        };
      };

      systemd.services.minecraft-server-al = {
        wantedBy = ["multi-user.target"];
        after = ["network-online.target"];
        environment = {
          LD_LIBRARY_PATH = lib.makeLibraryPath [ pkgs.udev ];
        };
        unitConfig = {
          BindsTo = ["minecraft-server-al-stdin.socket"];
        };
        serviceConfig = {
          Type = "exec";
          DynamicUser = true;
          StateDirectory = "minecraft-server/al";
          WorkingDirectory = "/var/lib/minecraft-server/al";
          # revert undocumented behavior: DynamicUser= implies StateDirectory= mounted noexec
          ExecPaths = "/var/lib/minecraft-server/al";
          ExecStart = "${pkgs.temurin-jre-bin-25}/bin/java -Xms3G -Xmx3G -jar fabric-server-mc.26.2-loader.0.19.5-launcher.1.1.2.jar nogui";
          StandardInput = "socket";
          StandardOutput = "journal";
          Restart = "always";
        };
      };

      environment.systemPackages = [
        (pkgs.writeShellApplication {
          name = "mcattach";
          text = ''
            id="$*";
            service="minecraft-server-$id.service";
            stdin_pipe="/run/minecraft-server-$id-stdin";

            if ! ${pkgs.systemd}/bin/systemctl cat "$service" &>/dev/null; then
              echo "$service does not exist!";
              exit 1;
            fi

            if ! ${pkgs.systemd}/bin/systemctl -q is-active "$service"; then
              echo "$service down";
              exit 1;
            fi

            trap 'pkill -P $$' EXIT;
            ${pkgs.systemd}/bin/journalctl -f -o cat -I -u "$service" &
            dd bs=1 conv=nocreat of="$stdin_pipe" status=none < /dev/stdin &
            wait -n;
          '';
          bashOptions = ["nounset"];
        })
      ];
   })
  ];
}

