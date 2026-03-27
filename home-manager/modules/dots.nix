{
  lib,
  pkgs,
  config,
  ghosttyMain,
  # zedMain,
  spotMain,
  ...
}: {
  # -- TERMINALS

  programs.ghostty = {
    # package = ghosttyMain;
    enable = true;
    systemd.enable = true;

    settings = {
      resize-overlay = "never";
      window-padding-balance = true;
      cursor-style-blink = true;
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

  programs.kitty = {
    enable = true;
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

  # --

  programs.jujutsu.enable = true;
  programs.delta = {
    enable = true;
    # enableJujutsuIntegration = true;
    # enableGitIntegration = true;
  };

  programs.yazi = {
    enable = true;
    initLua = ../dots/yazi/init.lua;
    settings = lib.importTOML ../dots/yazi/yazi.toml;
    keymap = lib.importTOML ../dots/yazi/keymap.toml;
    plugins = {inherit (pkgs.yaziPlugins) git relative-motions;};
  };

  stylix.targets = {
    qt.enable = true;
    gtk.enable = true;
    gtk.extraCss = "* { border-radius: 0; }";

    yazi.enable = false;
  };
  # -- shell stuff

  programs.zellij.enable = true;
  programs.bat.enable = true;

  # stylix.targets.nushell.enable = false;
  programs.nushell = {
    enable = true;
    configFile.source = ../dots/nu/config.nu;
  };

  # -- EDITORS --

  stylix.targets.zed.enable = false;
  programs.zed-editor = {
    enable = true;
    # package = zedMain;
  };

  # -- CLI / TUI --

  programs.starship = {
    enable = true;
    settings = lib.importTOML ../dots/starship/nerd_font_symbols.toml;
  };

  programs.zoxide.enable = true;

  programs.fastfetch = {
    enable = true;
    settings = lib.importJSON ../dots/fastfetch/config.jsonc;
  };

  programs.btop = {
    enable = true;
    settings.vim_keys = true;
    settings.rounded_corners = false;
  };

  stylix.targets.fzf.enable = false;
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--color 16"
      "--layout reverse"
      "--preview-window right:50%:sharp"
      "--prompt '❯ '"
    ];

    fileWidgetCommand = "fd --type f";
    fileWidgetOptions = ["--preview 'bat --color always {}'"];
  };

  # --

  programs.zathura = {
    enable = true;
    options = {
      first-page-column = "1:1";
      statusbar-home-tilde = true;
      window-title-home-tilde = true;
      statusbar-basename = true;
      window-title-basename = true;
      recolor = true;
      recolor-keephue = true;
      selection-clipboard = "clipboard";
    };
  };

  stylix.targets.spotify-player.enable = false;
  programs.spotify-player = {
    enable = true;
    # package = spotMain;
    settings = {
      progress_bar_position = "Right";
      cover_img_width = 7;
      cover_img_length = 16;
      layout.library.playlist_percent = 30;
      layout.playback_window_position = "Bottom";
      theme = "custom";
      pause_icon = "󰐊";
      play_icon = "󰏤";
      liked_icon = "󰐕";
    };
    themes = [
      {
        name = "custom";
        component_style = {
          border.fg = "BrightBlack";
          playback_album.fg = "Blue";
          playback_metadata.fg = "White";
          playback_genres.fg = "White";
          like.fg = "Red";
        };
      }
    ];
  };

  programs.rofi.enable = true;
  home.file = {
    "${config.xdg.configHome}/rofi".source = ../dots/rofi;
    "${config.xdg.configHome}/scripts" = {
      source = ../dots/scripts;
      executable = true;
    };
  };
}
