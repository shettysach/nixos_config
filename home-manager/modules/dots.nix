{spotify-player, ...}: {
  programs = {
    delta.enable = true;
    jujutsu.enable = true;

    imv.enable = true;
    mpv.enable = true;

    btop = {
      enable = true;
      settings = {
        rounded_corners = false;
        vim_keys = true;
      };
    };

    zathura = {
      enable = true;
      options = {
        guioptions = "vh";
        selection-clipboard = "clipboard";
        recolor-keephue = true;
      };
    };

    obsidian = {
      enable = true;
      cli.enable = true;
    };

    spotify-player = {
      enable = true;
      package = spotify-player;
      settings = {
        progress_bar_position = "Right";
        cover_img_width = 7;
        cover_img_length = 16;
        layout.library.playlist_percent = 40;
        layout.library.album_percent = 40;
        layout.playback_window_position = "Bottom";
        enable_relative_line_number = true;
        theme = "custom";
        pause_icon = "󰐊";
        play_icon = "󰏤";
        liked_icon = "󰐕";
      };
      themes = [
        {
          name = "custom";
          component_style.border.fg = "BrightBlack";
        }
      ];
    };
  };
}
