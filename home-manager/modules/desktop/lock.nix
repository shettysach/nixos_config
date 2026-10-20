{
  pkgs,
  config,
  ...
}: let
  lockCmd = "${pkgs.gtklock}/bin/gtklock --daemonize";
  niri = "${config.programs.niri.package}/bin/niri";
in {
  services.swayidle = {
    enable = true;
    systemdTargets = ["graphical-session.target"];

    events = {
      "before-sleep" = lockCmd;
      "lock" = lockCmd;
    };

    timeouts = [
      {
        timeout = 180;
        command = lockCmd;
      }
      {
        timeout = 300;
        command = "${niri} msg action power-off-monitors";
        resumeCommand = "${niri} msg action power-on-monitors";
      }
      {
        timeout = 1200;
        command = "${pkgs.systemd}/bin/systemctl hibernate";
      }
    ];
  };
}
