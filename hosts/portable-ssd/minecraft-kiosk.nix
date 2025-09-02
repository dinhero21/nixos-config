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

     environment.systemPackages = with pkgs; [
       prismlauncher
     ];

     kiosk = {
       enable = true;
       program = "prismlauncher --launch 'Fabulously Optimized'";
     };
   })
  ];
}

