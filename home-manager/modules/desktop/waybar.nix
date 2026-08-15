{lib, ...}: {
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      targets = ["graphical-session.target"];
    };
    style = lib.mkAfter (builtins.readFile ../../dots/waybar/style.css);
    settings = {
      mainBar = {
        layer = "top";
        position = "top";

        margin-top = 0;
        margin-bottom = 0;
        margin-right = 0;
        margin-left = 0;

        modules-left = [
          "clock"
          "cpu"
          "memory"
          "disk#one"
          "mpris"
        ];

        modules-center = ["niri/workspaces"];

        modules-right = ["tray" "idle_inhibitor" "backlight" "wireplumber#sink" "wireplumber#source" "network" "battery"];

        clock = {
          format = "{:%a %d %b %H:%M}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
        };

        cpu = {
          states = {
            good = 0;
            warning = 70;
            critical = 90;
          };
          interval = 10;
          format = "CPU {usage:2}%";
        };

        memory = {
          states = {
            good = 0;
            warning = 70;
            critical = 85;
          };
          interval = 10;
          format = "MEM {:2}%";
        };

        "disk#one" = {
          states = {
            good = 0;
            warning = 70;
            critical = 95;
          };
          interval = 30;
          format = "DISK {percentage_used:2}%";
          path = "/";
        };

        tray = {
          icon-size = 16;
          spacing = 8;
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󱙱 ";
            deactivated = "󰌾 ";
          };
        };

        backlight = {
          format = "BRI {percent}%";
        };

        "wireplumber#sink" = {
          format = "SPK {volume}%";
          format-muted = "SPK MUTE";
          on-click = "pavucontrol -t 3";
          on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };

        "wireplumber#source" = {
          node-type = "Audio/Source";
          format = "MIC {volume}%";
          format-muted = "MIC MUTE";
          on-click = "pavucontrol -t 4";
          on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        };

        mpris = {
          format = "MPRIS 󰏤";
          format-paused = "MPRIS 󰐊";
          format-stopped = "";
          tooltip-format = "{dynamic}\n{player}";
          dynamic-separator = "\n";
          players = ["*"];
          on-click = "playerctl play-pause";
          interval = 1;
        };

        network = {
          format-wifi = "WIFI {signalStrength}%";
          format-ethernet = "ETH {ifname}";
          format-disconnected = "NONE";
          tooltip-format = "{essid} - {ifname}";
          tooltip-format-disconnected = "Disconnected";
          interval = 30;
        };

        battery = {
          states = {
            good = 80;
            warning = 35;
            critical = 20;
          };
          format = "BAT {capacity}%";
          format-charging = "CHG {capacity}%";
          events = {
            on-discharging-warning = "notify-send -u low 'BATTERY LOW' -t 60000";
            on-discharging-critical = "notify-send -u critical 'BATTERY CRITICAL' -t 60000";
          };
          interval = 30;
        };
      };
    };
  };
}
