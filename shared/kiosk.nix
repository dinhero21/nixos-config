{ config, lib, pkgs, ... }:

let cfg = config.kiosk; in {
  imports = [
    ./audio.nix
  ];

  options.kiosk = {
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
    #   default = true;
    #   description = "display program stderr/stdout via foot";
    # };
    # TODO:
    # drop-capabilities = lib.mkOption {
    #   type = lib.types.boolean;
    #   default = true;
    #   description = "clean ambient capabilities, polluted by services.cage - needed for bwrap";
    # };
  };

  config = lib.mkIf cfg.enable {
    system.nixos.tags = [ "kiosk" ];

    fonts.enableDefaultPackages = true;
    programs.foot.enable = true;

    audio.enable = true;

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
      # services.cage pollutes ambient capabilities with cap_wake_alarm because of PAM integration
      # this breaks programs that don't expect it, such as bwrap
      # to revert it, we use setpriv --ambient-caps -all to clear ambient capabilities
      program = "${pkgs.foot}/bin/foot --maximized --fullscreen -- ${pkgs.util-linux}/bin/setpriv --ambient-caps -all -- ${cfg.program}";
      # program = "${pkgs.foot}/bin/foot --maximized --fullscreen -- ${cfg.program}";
      # program = "${pkgs.foot}/bin/foot --maximized --fullscreen";
    };
  };
}
