{
  pkgs,
  config,
  ...
}: {
  services.swayidle = {
    enable = true;
    events = {
      "before-sleep" = "${pkgs.hyprlock}/bin/hyprlock";
      "lock" = "${pkgs.hyprlock}/bin/hyprlock";
    };

    timeouts = [
      {
        timeout = 5 * 60;
        command = "${pkgs.hyprlock}/bin/hyprlock";
      }
      {
        timeout = 10 * 60;
        command = "niri msg action power-off-monitors";
        resumeCommand = "niri msg action power-on-monitors";
      }
      {
        timeout = 15 * 60;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
  };
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        grace = 5;
      };
      label = [
        {
          monitor = "";
          text = "$TIME";
          color = config.lib.stylix.colors.base05 + "77";
          font_family = config.stylix.fonts.sansSerif.name;
          font_size = 200;
          position = "0, 250";
          valign = "center";
          halign = "center";
          shadow_passes = 2;
        }
      ];
    };
  };
}
