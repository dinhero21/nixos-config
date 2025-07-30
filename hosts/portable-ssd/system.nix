{ flake-inputs, ... }:

flake-inputs.nixpkgs.lib.nixosSystem {
  specialArgs = { inherit flake-inputs; };
  modules = [
   ({ config, lib, pkgs, ... }: {
      imports = [
       ./hardware.nix
       ../../shared/common.nix
       ../../shared/desktop/environment.nix
      ];

      networking.hostName = "portable-ssd";
 
      # Programs
    
      programs.firefox.enable = true;
    
      # programs.steam.enable = true;
    
      environment.systemPackages = with pkgs; [
        # prismlauncher vesktop
      ];
   })
  ];
}

