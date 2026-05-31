{ flake-inputs, ... }:

flake-inputs.nixpkgs.lib.nixosSystem {
  specialArgs = { inherit flake-inputs; };
  modules = [
   ({ config, lib, pkgs, ... }: {
      imports = [
       ./hardware.nix
       ../../shared/common.nix
       ../../shared/kiosk.nix
      ];

      networking.hostName = "portable-ssd";

      programs.steam.enable = true;
      system.nixos.tags = [ "steam" ];

      kiosk = {
        enable = true;
        program = "${lib.getExe pkgs.steam} -gamepadui -applaunch 230290";
      };
   })
  ];
}

