{ config, pkgs, ... }:

{
  # taken from https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/installer/cd-dvd/installation-cd-base.nix
  hardware.enableAllHardware = true;
}
