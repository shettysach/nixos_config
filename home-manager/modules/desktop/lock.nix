{
  pkgs,
  config,
  ...
}: let
  pidof = "${pkgs.procps}/bin/pidof";
  hyprlock = "${config.programs.hyprlock.package}/bin/hyprlock";
  lockCmd = "${pidof} hyprlock || ${hyprlock}";

  niri = "${config.programs.niri.package}/bin/niri";
  bat = "${config.programs.bat.package}/bin/bat --plain ";
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
        command = "${lockCmd}  --grace 5";
      }
      {
        timeout = 300;
        command = "${niri} msg action power-off-monitors";
        resumeCommand = "${niri} msg action power-on-monitors";
      }
      {
        timeout = 480;
        command = "${pkgs.systemd}/bin/systemctl hibernate";
      }
    ];
  };

  programs.hyprlock = {
    enable = true;
    settings = {
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

        {
          monitor = "";
          text = ''cmd[update:60000] echo $(${bat} /sys/class/power_supply/BAT*/status) $(${bat} /sys/class/power_supply/BAT*/capacity)%'';
          color = "rgba(" + config.lib.stylix.colors.base05 + "D9)";
          font_family = config.stylix.fonts.serif.name;
          font_size = 40;
          position = "0, -240";
          valign = "center";
          halign = "center";
          shadow_passes = 3;
          shadow_size = 6;
        }
      ];
    };
  };
}
