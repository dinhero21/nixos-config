{ config, pkgs, flake-inputs, ... }:

{
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  
  home-manager.sharedModules = [
    flake-inputs.plasma-manager.homeManagerModules.plasma-manager
  ];

  home-manager.users.dinhero21 = {
    programs.plasma =
      let
        wallpaper = "${pkgs.nixos-artwork.wallpapers.nineish-dark-gray}/share/backgrounds/nixos/nix-wallpaper-nineish-dark-gray.png";
      in
    {
      enable = true;

      workspace = {
        lookAndFeel = "org.kde.breezedark.desktop";
        wallpaper = wallpaper;
      };

      kscreenlocker.appearance.wallpaper = wallpaper;

      powerdevil = {
        AC = {
          # this has made me corrupt partitions before, why isn't this the default?
          # respectfully, fuck you KDE /hj
          autoSuspend.action = "nothing";
        };
      };
    };
  };
}
