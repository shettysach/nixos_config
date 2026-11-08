{ghostty, ...}: {
  programs = {
    ghostty = {
      enable = true;
      package = ghostty;
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

          # Open scrollback in Neovim from Vim mode.
          "vim/e=text:nvim -R +\\x20"
          "chain=write_scrollback_file:paste"
          "chain=text:\\r"

          # Vim-style scrollback mode (Ghostty 1.3+).
          "alt+v=activate_key_table:vim"
          "vim/"

          # Line and page movement.
          "vim/j=scroll_page_lines:1"
          "vim/k=scroll_page_lines:-1"
          "vim/ctrl+d=scroll_page_down"
          "vim/ctrl+u=scroll_page_up"
          "vim/ctrl+f=scroll_page_down"
          "vim/ctrl+b=scroll_page_up"
          "vim/shift+j=scroll_page_down"
          "vim/shift+k=scroll_page_up"
          "vim/g>g=scroll_to_top"
          "vim/shift+g=scroll_to_bottom"

          # Search and copy the current selection.
          "vim/slash=start_search"
          "vim/n=navigate_search:next"
          "vim/v=copy_to_clipboard"
          "vim/y=copy_to_clipboard"
          "vim/shift+semicolon=toggle_command_palette"

          # Exit mode and consume unbound keys.
          "vim/escape=deactivate_key_table"
          "vim/q=deactivate_key_table"
          "vim/i=deactivate_key_table"
          "vim/catch_all=ignore"
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
