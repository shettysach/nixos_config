{
  pkgs,
  config,
  ...
}: let
  pidof = "${pkgs.procps}/bin/pidof";
  hyprlock = "${config.programs.hyprlock.package}/bin/hyprlock";
  lockCmd = "${pidof} hyprlock || ${hyprlock}";
  # niri = "${config.programs.niri.package}/bin/niri";
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
        timeout = 300;
        command = lockCmd;
      }
      {
        timeout = 450;
        command = "niri msg action power-off-monitors";
        resumeCommand = "niri msg action power-on-monitors";
      }
      {
        timeout = 600;
        command = "systemctl suspend";
      }
    ];
  };

  programs.hyprlock = {
    enable = true;
    package = pkgs.hyprlock;
    settings = {
      general = {
        grace = 5;
      };
      label = [
        {
          monitor = "";
          text = "$TIME";
          color = "rgba(" + config.lib.stylix.colors.base05 + "D9)";
          font_family = config.stylix.fonts.serif.name;
          font_size = 200;
          position = "0, 250";
          valign = "center";
          halign = "center";
          shadow_passes = 3;
          shadow_size = 6;
        }

        {
          monitor = "";
          text = ''cmd[update:43200000] echo $(/run/current-system/sw/bin/date +"%A, %d %b %Y")'';
          color = "rgba(" + config.lib.stylix.colors.base05 + "D9)";
          font_family = config.stylix.fonts.serif.name;
          font_size = 50;
          position = "0, -150";
          valign = "center";
          halign = "center";
          shadow_passes = 3;
          shadow_size = 6;
        }
      ];
    };
  };
}
