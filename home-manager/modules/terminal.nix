{
  programs = {
    ghostty = {
      enable = true;
      systemd.enable = true;
      settings = {
        quit-after-last-window-closed = false;
        resize-overlay = "never";
        window-padding-balance = true;
        cursor-style-blink = false;
        window-decoration = false;
        confirm-close-surface = false;
        window-inherit-working-directory = false;
        keybind = [
          "super+enter=new_split:auto"
          "super+backspace=close_surface"
          "super+h=goto_split:left"
          "super+j=goto_split:down"
          "super+k=goto_split:up"
          "super+l=goto_split:right"
        ];
      };
    };
    kitty = {
      enable = false;
      settings = {
        tab_bar_edge = "bottom";
        hide_window_decorations = "yes";
        confirm_os_window_close = 0;
        enable_audio_bell = "no";
        enabled_layouts = "splits:split_axis=auto";
        inactive_text_alpha = 0.5;
      };
      keybindings = {
        "super+enter" = "launch --cwd=current --location=split";
        "super+backspace" = "close_window";
        "super+h" = "neighboring_window left";
        "super+j" = "neighboring_window down";
        "super+k" = "neighboring_window up";
        "super+l" = "neighboring_window right";
      };
    };
  };
}
