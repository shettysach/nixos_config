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
        font-feature = "-calt,zero";
        keybind = [
          "super+enter=new_split:auto"
          "super+backspace=close_surface"
          "super+h=goto_split:left"
          "super+j=goto_split:down"
          "super+k=goto_split:up"
          "super+l=goto_split:right"
          "alt+v=activate_key_table:copy"
          "copy/"
          "copy/j=scroll_page_lines:1"
          "copy/k=scroll_page_lines:-1"
          "copy/ctrl+d=scroll_page_down"
          "copy/ctrl+u=scroll_page_up"
          "copy/ctrl+f=scroll_page_down"
          "copy/ctrl+b=scroll_page_up"
          "copy/shift+j=scroll_page_lines:1"
          "copy/shift+k=scroll_page_lines:-1"
          "copy/g>g=scroll_to_top"
          "copy/shift+g=scroll_to_bottom"
          "copy/slash=start_search"
          "copy/n=navigate_search:next"
          "copy/v=write_scrollback_file:open,plain"
          "chain=deactivate_key_table"
          "copy/y=write_scrollback_file:open,plain"
          "chain=deactivate_key_table"
          "copy/shift+semicolon=toggle_command_palette"
          "copy/escape=deactivate_key_table"
          "copy/q=deactivate_key_table"
          "copy/i=deactivate_key_table"
          "copy/catch_all=ignore"
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
