{ config, pkgs, flake-inputs, ... }:

{
  imports = [
    flake-inputs.home-manager.nixosModules.default
  ];

  # Enable experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true; 

  # Enable networking
  networking.networkmanager.enable = true;

  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # TODO: brazilian keyboard toggle

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Define a user account. Don't forget to set a password with ‘passwd’!
  users.users.dinhero21 = {
    isNormalUser = true;
    description = "dinhero21";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager.useUserPackages = true; # not sure why, alledgely necessary for nixos-rebuild build-vm
  home-manager.useGlobalPkgs = true; # faster evaluation, better consistency

  home-manager.users.dinhero21 = {
    programs = {
      git = {
        enable = true;
        userName = "dinhero21";
        userEmail = "dinhero21@dinhero21.dev";
      };
    };

    # This value determines the Home Manager release that your configuration is 
    # compatible with. This helps avoid breakage when a new Home Manager release 
    # introduces backwards incompatible changes. 
    #
    # You should not change this value, even if you update Home Manager. If you do 
    # want to update the value, then make sure to first check the Home Manager 
    # release notes.
    home.stateVersion = "25.05"; # Please read the comment before changing.
  };

  nixpkgs.config.allowUnfree = true;

  # Programs

  programs.vim = {
    enable = true;
    defaultEditor = true;
  };
  
  programs.git.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment? 
}
