{
  pkgs,
  config,
  ...
}: {
  services.swayidle = {
    enable = true;
    events = {
      "before-sleep" = "${config.programs.hyprlock.package}/bin/hyprlock";
      "lock" = "${config.programs.hyprlock.package}/bin/hyprlock";
    };

    timeouts = [
      {
        timeout = 5 * 60;
        command = "${config.programs.hyprlock.package}/bin/hyprlock";
      }
      {
        timeout = 10 * 60;
        command = "niri msg action power-off-monitors";
        resumeCommand = "niri msg action power-on-monitors";
      }
      {
        timeout = 15 * 60;
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
          color = "rgba(" + config.lib.stylix.colors.base07 + "85)";
          font_family = config.stylix.fonts.serif.name;
          font_size = 200;
          position = "0, 250";
          valign = "center";
          halign = "center";
          shadow_passes = 4;
        }

        {
          monitor = "";
          text = ''cmd[update:43200000] echo $(date +"%A, %d %b %Y")'';
          color = "rgba(" + config.lib.stylix.colors.base07 + "85)";
          font_family = config.stylix.fonts.serif.name;
          font_size = 50;
          position = "0, -150";
          valign = "center";
          halign = "center";
          shadow_passes = 4;
        }
      ];
    };
  };
}
