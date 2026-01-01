{
  lib,
  config,
  ghosttyMain,
  helixMain,
  pkgs,
  # zedMain,
  ...
}: {
  programs.bat.enable = true;
  programs.rofi.enable = true;

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
    plugins = {inherit (pkgs.yaziPlugins) yatline git relative-motions;};
  };

  stylix.targets = {
    qt.enable = true;
    gtk.enable = true;
    gtk.extraCss = "* { border-radius: 0; }";
  };

  # -- Terminals

  programs.ghostty = {
    package = ghosttyMain;
    enable = false;
    settings = {
      resize-overlay = "never";
      window-padding-balance = true;
      cursor-invert-fg-bg = true;
      cursor-style-blink = true;
      window-decoration = false;
      confirm-close-surface = false;
      window-inherit-working-directory = false;
      keybind = [
        # Entry point
        "super+v=activate_key_table:vim"

        # Key table definition
        "vim/"

        # Line movement
        "vim/j=scroll_page_lines:1"
        "vim/k=scroll_page_lines:-1"

        # Page movement
        "vim/ctrl+d=scroll_page_down"
        "vim/ctrl+u=scroll_page_up"
        "vim/ctrl+f=scroll_page_down"
        "vim/ctrl+b=scroll_page_up"
        "vim/shift+j=scroll_page_down"
        "vim/shift+k=scroll_page_up"

        # Jump to top/bottom
        "vim/g>g=scroll_to_top"
        "vim/shift+g=scroll_to_bottom"

        # Search (vim-style search entry)
        "vim/slash=start_search"
        "vim/n=navigate_search:next"

        # Copy mode / selection
        "vim/v=copy_to_clipboard"
        "vim/y=copy_to_clipboard"

        # Command Palette
        "vim/shift+semicolon=toggle_command_palette"

        # Exit
        "vim/escape=deactivate_key_table"
        "vim/q=deactivate_key_table"
        "vim/i=deactivate_key_table"

        # Catch unbound keys
        "vim/catch_all=ignore"

        # Your existing binds (kept)
        "ctrl+h=goto_split:left"
        "ctrl+l=goto_split:right"
      ];
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      tab_bar_edge = "bottom";
      hide_window_decorations = "yes";
      confirm_os_window_close = 0;
    };
  };

  programs.alacritty = {
    enable = false;
    settings = {
      window.decorations = "None";
      window.dynamic_padding = true;
    };
  };

  programs.zellij.enable = true;

  # --

  # stylix.targets.nushell.enable = false;
  programs.nushell = {
    enable = true;
    configFile.source = ../dots/nu/config.nu;
  };

  # -- EDITORS --

  programs.neovide = {
    enable = true;
    settings = {
      frame = "none";
      title-hidden = true;
    };
  };

  stylix.targets.zed.enable = false;
  programs.zed-editor = {
    enable = true;
    # package = zedMain;
  };

  programs.helix = {
    enable = true;
    # package = helixMain;
    settings = lib.importTOML ../dots/helix/config.toml;
    languages = lib.importTOML ../dots/helix/languages.toml;
    themes.transparent = lib.importTOML ../dots/helix/transparent.toml;
  };
  stylix.targets.helix.enable = false;

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

  stylix.targets.waybar.addCss = true;
  programs.waybar = {
    enable = true;
    settings = lib.importJSON ../dots/waybar/config.json;
    style = lib.mkAfter (builtins.readFile ../dots/waybar/style.css);
  };

  stylix.targets.spotify-player.enable = false;
  programs.spotify-player = {
    enable = true;
    settings = {
      progress_bar_position = "Right";
      cover_img_width = 7;
      cover_img_length = 16;
      layout = {
        library.playlist_percent = 30;
        playback_window_position = "Bottom";
      };
      theme = "custom";
    };
    themes = [
      {
        name = "custom";
        component_style.border.fg = "BrightBlack";
      }
    ];
  };

  home.file = {
    "${config.xdg.configHome}/rofi".source = ../dots/rofi;
    "${config.xdg.configHome}/scripts" = {
      source = ../dots/scripts;
      executable = true;
    };
  };
}
