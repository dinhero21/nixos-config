{ lib, ... }:

{
  imports = [
    ../audio.nix
    ./plasma.nix
  ];

  # Enable X11 (should I? wayland is supported on every device I use)
  services.xserver.enable = lib.mkDefault true;

  # Enable CUPS to print documents.
  services.printing.enable = lib.mkDefault true;

  audio.enable = lib.mkDefault true;

  networking.networkmanager.enable = lib.mkDefault true;
}

