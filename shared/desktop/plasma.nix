{ config, pkgs, flake-inputs, ... }:

{
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  
  home-manager.sharedModules = [
    flake-inputs.plasma-manager.homeManagerModules.plasma-manager
  ];
}
