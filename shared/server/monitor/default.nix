{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    btop
  ];

  users.users.monitor = {
    isSystemUser = true;
    group = "nogroup";
    # shell = "${pkgs.btop}/bin/btop";
    # pkgs.writers.writeDash doesn't work because shell doesn't accept a symlink for whatever reason
    shell = "${pkgs.writers.writeDashBin "monitor-script" "while true; do HOME=\"\$(mktemp -d)\" btop --config ${./btop.conf}; echo btop exited, retrying in 1s...; sleep 1; done"}/bin/monitor-script";
  };

  services.getty = {
    autologinUser = "monitor";
    autologinOnce = true;
  };
}
