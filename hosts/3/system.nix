{ flake-inputs, ... }:

flake-inputs.nixpkgs.lib.nixosSystem {
  specialArgs = { inherit flake-inputs; };
  modules = [
    ./hardware.nix
    ../../shared/common.nix
    ../../shared/desktop/environment.nix
    ({ config, pkgs, ... }: {
      networking.hostName = "3";
 
      # Programs
    
      programs.firefox.enable = true;
    
      # programs.steam.enable = true;
    
      environment.systemPackages = with pkgs; [
        # prismlauncher vesktop
      ];
    })
  ];
}

