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

     system.nixos.tags = [ "minecraft" ];

     kiosk = {
       enable = true;
       program = "${lib.getExe pkgs.prismlauncher} --launch 'Fabulously Optimized'";
     };
   })
  ];
}

