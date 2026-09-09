{ config, pkgs, ... }:

{
  imports = [
    ./monitor
    ./ssh
  ];  
}
