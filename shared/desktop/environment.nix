{ config, pkgs, ... }:

{
  imports = [
    ../audio.nix
    ./plasma.nix
  ];

  # Enable X11 (should I? wayland is supported on every device I use)
  services.xserver.enable = true; 

  # Enable CUPS to print documents.
  services.printing.enable = true;

  audio.enable = true;
}
 
