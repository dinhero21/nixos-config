{ config, lib, pkgs, ... }:

let cfg = config.kiosk; in {
  options = {
    kiosk = {
      enable = lib.mkEnableOption "Enable Kiosk - Single Fullscreen App DE";
      program = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "program to run, empty string (default) for interactive shell";
        example = "firefox --kiosk https://dinhero21.dev/";
      };
      # TODO:
      # terminal = lib.mkOption {
      #   type = lib.types.boolean;
      #   description = "display program stderr/stdout via foot"
      # };
    };
  };

  config = lib.mkIf cfg.enable {
    system.nixos.tags = [ "minecraft-kiosk" ];
  
    fonts.enableDefaultPackages = true;
  
    programs.foot.enable = true;
  
    services.cage = {
      enable = true;
      # allow vt-switching
      extraArguments = ["-s"];
      # fix keymapping
      environment = {
        XKB_DEFAULT_LAYOUT = config.services.xserver.xkb.layout;
        XKB_DEFAULT_MODEL = config.services.xserver.xkb.model;
        XKB_DEFAULT_OPTIONS = config.services.xserver.xkb.options;
        XKB_DEFAULT_VARIANT = config.services.xserver.xkb.variant;
      };
  
      user = "dinhero21";
      program = "${pkgs.foot}/bin/foot --maximized --fullscreen ${cfg.program}";
      # program = "${pkgs.foot}/bin/foot --maximized --fullscreen";
    };
  };
}
