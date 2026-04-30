{
  lib,
  pkgs,
  config,
  spotMain,
  ...
}: {
  programs = {
    # -- Shells
    zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;

      autosuggestion = {
        enable = true;
        strategy = ["history" "completion"];
      };

      historySubstringSearch = {
        enable = true;
        searchUpKey = "^P";
        searchDownKey = "^N";
      };

      plugins = [
        {
          name = "vi-mode";
          src = pkgs.zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }

        {
          name = "fzf-tab";
          src = pkgs.zsh-fzf-tab;
          file = "share/fzf-tab/fzf-tab.plugin.zsh";
        }
      ];

      shellAliases = {
        fzfh = "fd -H . | fzf";
        fzfp = "fzf --preview 'bat --color=always {}'";

        zed = "zeditor"; # zed = "MESA_VK_DEVICE_SELECT=10de:174d zeditor";
      };

      localVariables = {
        HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND = "";
        HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND = "";

        ZVM_VI_HIGHLIGHT_BACKGROUND = "magenta";
        ZVM_VI_EDITOR = "nvim";
        ZVM_INIT_MODE = "sourcing";

        NIXOS_CONFIG = "${config.xdg.configHome}/nix";
      };

      syntaxHighlighting.styles = {
        "arg0" = "fg=cyan";
        "path" = "fg=blue";
        "unknown-token" = "fg=white";
        "suffix-alias" = "fg=green";
        "precommand" = "fg=green";
        "autodirectory" = "fg=green";
        "comment" = "fg=black";
        "single-quoted-argument" = "fg=green";
        "double-quoted-argument" = "fg=green";
        "dollar-quoted-argument" = "fg=magenta";
      };

      initContent = ''
        function zvm_after_init() {
            bindkey '^r' fzf-history-widget
        }

        bindkey '^o' autosuggest-accept

        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:*' switch-group '<' '>'
        zstyle ':fzf-tab:*' fzf-flags --color=16 --preview-window=sharp --prompt='❯ '
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsr -1 $realpath'
      '';

      history.size = 1000;
      history.saveNoDups = true;
    };

    # -- Terminals
    ghostty = {
      # package = ghosttyMain;
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

    # -- Shell utils

    zellij.enable = true;
    bat.enable = true;
    nushell = {
      enable = false;
      configFile.source = ../dots/nu/config.nu;
    };
    starship = {
      enable = true;
      settings = lib.importTOML ../dots/starship/nerd_font_symbols.toml;
    };
    zoxide.enable = true;
    jujutsu.enable = true;
    delta.enable = true;
    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultOptions = [
        "--color base16"
        "--layout reverse"
        "--preview-window right:50%:sharp"
        "--prompt '❯ '"
      ];

      fileWidgetCommand = "fd --type f";
      fileWidgetOptions = ["--preview 'bat --color always {}'"];
    };

    # --

    zed-editor.enable = true;
    btop = {
      enable = true;
      settings.vim_keys = true;
      settings.rounded_corners = false;
    };
    spotify-player = {
      enable = true;
      package = spotMain;
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
  };
}
