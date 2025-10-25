{
  pkgs,
  config,
  ...
}: let
  scripts = "${config.xdg.configHome}/scripts";
in {
  programs.niri.enable = true;
  services.wpaperd.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];

    config.common.default = "*";
  };

  services.mako = {
    enable = true;
    settings.default-timeout = 5000;
  };

  programs.niri.settings = {
    overview = {
      backdrop-color = config.lib.stylix.colors.base00;
      workspace-shadow.enable = false;
    };

    environment = {
      CLUTTER_BACKEND = "wayland";
      # DISPLAY = null;
      GDK_BACKEND = "wayland,x11";
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
      # QT_QPA_PLATFORM = "wayland;xcb";
      # QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      # QT_QPA_PLATFORMTHEME = "gtk3";
      SDL_VIDEODRIVER = "wayland";

      WLR_NO_HARDWARE_CURSORS = "1";

      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      LIBVA_DRIVER_NAME = "nvidia";

      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "niri";
    };

    spawn-at-startup = [
      {command = ["${pkgs.waybar}/bin/waybar"];}
      {command = ["${pkgs.clipse}/bin/clipse" "-listen"];}
    ];

    hotkey-overlay.skip-at-startup = true;
    input.focus-follows-mouse.enable = true;

    layout.border.width = 2;
    layout.gaps = 4;

    animations.enable = true;
    animations.slowdown = 0.5;
    animations.window-resize.enable = false;

    input.mod-key = "Alt";
    input.mod-key-nested = "Super";

    layout.preset-column-widths = [{proportion = 0.5;} {proportion = 1.0;}];

    binds = {
      "Mod+Return".action.spawn = ["nvidia-offload" "ghostty"];

      "Mod+Backspace".action.close-window = {};
      "Mod+D".action.spawn = ["${pkgs.rofi}/bin/rofi" "-show" "drun"];

      "Mod+X".action.show-hotkey-overlay = {};

      "Mod+Q".action.spawn = ["killall" "-SIGUSR1" ".waybar-wrapped"];

      "Mod+K".action.focus-window-or-workspace-up = {};
      "Mod+J".action.focus-window-or-workspace-down = {};
      "Mod+H".action.focus-column-left = {};
      "Mod+L".action.focus-column-right = {};
      "Mod+F".action.fullscreen-window = {};
      "Mod+Backslash".action.switch-preset-column-width = {};
      "Mod+W".action.toggle-overview = {};

      "Mod+Shift+H".action.move-column-left = {};
      "Mod+Shift+J".action.move-window-down-or-to-workspace-down = {};
      "Mod+Shift+K".action.move-window-up-or-to-workspace-up = {};
      "Mod+Shift+L".action.move-column-right = {};

      "Mod+BracketLeft".action.consume-or-expel-window-left = {};
      "Mod+BracketRight".action.consume-or-expel-window-right = {};

      "Mod+Equal".action.set-column-width = "+10%";
      "Mod+Minus".action.set-column-width = "-10%";

      "Mod+M".action.spawn = ["${pkgs.rofi}/bin/rofi" "-show" "power-menu" "-modi" "power-menu:${scripts}/power_menu --no-symbols"];
      "Mod+Shift+B".action.spawn = ["bash" "${scripts}/bluetooth_menu"];

      "Mod+S".action.screenshot = {};
      "Mod+Space".action.switch-focus-between-floating-and-tiling = {};
      "Mod+Shift+Space".action.toggle-window-floating = {};

      "XF86AudioRaiseVolume" = {
        allow-when-locked = true;
        action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"];
      };

      "XF86AudioLowerVolume" = {
        allow-when-locked = true;
        action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"];
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
        action.spawn = ["light" "-U" "5"];
      };

      "XF86MonBrightnessUp" = {
        allow-when-locked = true;
        action.spawn = ["light" "-A" "5"];
      };

      "XF86AudioPlay" = {
        allow-when-locked = true;
        action.spawn = ["playerctl" "play-pause"];
      };

      "XF86AudioPause" = {
        allow-when-locked = true;
        action.spawn = ["playerctl" "play-pause"];
      };

      "XF86AudioNext" = {
        allow-when-locked = true;
        action.spawn = ["playerctl" "next"];
      };

      "XF86AudioPrev" = {
        allow-when-locked = true;
        action.spawn = ["playerctl" "prev"];
      };
    };

    window-rules = [
      {
        draw-border-with-background = false;
        default-column-width.proportion = 1.0;
        # open-floating = false;
      }
    ];
  };

  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock";
      }

      {
        event = "lock";
        command = "${pkgs.swaylock}/bin/swaylock";
      }
    ];

    timeouts = [
      {
        timeout = 5 * 60;
        command = "${pkgs.swaylock}/bin/swaylock";
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
}
