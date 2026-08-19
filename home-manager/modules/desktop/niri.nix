{
  pkgs,
  config,
  ...
}: {
  programs.niri = {
    enable = true;
    package = pkgs.niri;

    settings = {
      overview = {
        backdrop-color = config.lib.stylix.colors.base00;
        workspace-shadow.enable = false;
      };

      prefer-no-csd = true;
      window-rules = [
        {
          draw-border-with-background = false;
          default-column-width.proportion = 1.0;
          excludes = [{is-floating = true;}];
        }
      ];

      environment = {
        CLUTTER_BACKEND = "wayland";
        GDK_BACKEND = "wayland,x11";
        SDL_VIDEODRIVER = "wayland";
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";

        WLR_NO_HARDWARE_CURSORS = "1";

        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "niri";
      };

      hotkey-overlay.skip-at-startup = true;
      input.focus-follows-mouse.enable = true;

      layout.border.width = 1;
      layout.gaps = 0;

      animations.enable = true;
      animations.slowdown = 0.5;

      input.mod-key = "Alt";
      input.mod-key-nested = "Super";

      layout.preset-column-widths = [
        {proportion = 0.5;}
        {proportion = 1.0;}
      ];

      binds = {
        "Mod+Return".action.spawn = ["ghostty" "+new-window"];

        "Mod+Backspace".action.close-window = {};

        "Mod+Escape".action.toggle-keyboard-shortcuts-inhibit = {};

        "Mod+Q".action.spawn = ["killall" "-SIGUSR1" ".waybar-wrapped"];

        "Mod+K".action.focus-window-or-workspace-up = {};
        "Mod+J".action.focus-window-or-workspace-down = {};
        "Mod+H".action.focus-column-left = {};
        "Mod+L".action.focus-column-right = {};
        "Mod+F".action.fullscreen-window = {};

        "Mod+Backslash".action.switch-preset-column-width = {};
        "Mod+O".action.toggle-overview = {};

        "Mod+Shift+H".action.move-column-left = {};
        "Mod+Shift+J".action.move-window-down-or-to-workspace-down = {};
        "Mod+Shift+K".action.move-window-up-or-to-workspace-up = {};
        "Mod+Shift+L".action.move-column-right = {};

        "Mod+BracketLeft".action.consume-or-expel-window-left = {};
        "Mod+BracketRight".action.consume-or-expel-window-right = {};

        "Mod+Equal".action.set-column-width = "+5%";
        "Mod+Minus".action.set-column-width = "-5%";

        "Mod+W".action.spawn = ["${../../dots/scripts/window_switcher}"];

        "Mod+M".action.spawn = ["${../../dots/scripts/power_menu}"];

        "Mod+D".action.spawn = ["${config.programs.fuzzel.package}/bin/fuzzel"];
        "Mod+I".action.spawn = ["${pkgs.iwmenu}/bin/iwmenu" "-l" "fuzzel" "-s" "2"];
        "Mod+B".action.spawn = ["${pkgs.bzmenu}/bin/bzmenu" "-l" "fuzzel" "-s" "2"];

        "Mod+C".action.spawn = ["${config.services.clipcat.package}/bin/clipcat-menu"];

        "Mod+S".action.screenshot = {};
        "Mod+Space".action.switch-focus-between-floating-and-tiling = {};
        "Mod+Shift+Space".action.toggle-window-floating = {};

        "XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+"];
        };

        "XF86AudioLowerVolume" = {
          allow-when-locked = true;
          action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-"];
        };

        "XF86AudioMute" = {
          allow-when-locked = true;
          action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
        };

        "XF86AudioMicMute" = {
          allow-when-locked = true;
          action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
        };

        "XF86MonBrightnessDown" = {
          allow-when-locked = true;
          action.spawn = ["${pkgs.brightnessctl}/bin/brightnessctl" "set" "5%-"];
        };

        "XF86MonBrightnessUp" = {
          allow-when-locked = true;
          action.spawn = ["${pkgs.brightnessctl}/bin/brightnessctl" "set" "5%+"];
        };

        "XF86AudioPlay" = {
          allow-when-locked = true;
          action.spawn = ["${pkgs.playerctl}/bin/playerctl" "play-pause"];
        };

        "XF86AudioPause" = {
          allow-when-locked = true;
          action.spawn = ["${pkgs.playerctl}/bin/playerctl" "play-pause"];
        };

        "XF86AudioNext" = {
          allow-when-locked = true;
          action.spawn = ["${pkgs.playerctl}/bin/playerctl" "next"];
        };

        "XF86AudioPrev" = {
          allow-when-locked = true;
          action.spawn = ["${pkgs.playerctl}/bin/playerctl" "previous"];
        };
      };
    };
  };
}
