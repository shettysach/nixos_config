{
  lib,
  config,
  ghosttyMain,
  helixMain,
  # zedMain,
  ...
}: {
  programs.bat.enable = true;
  programs.rofi.enable = true;

  programs.spotify-player.enable = true;

  stylix.targets = {
    qt.enable = true;
    gtk.enable = true;
    gtk.extraCss = "* { border-radius: 0; }";
    spotify-player.enable = false;
  };

  # -- Terminals

  programs.ghostty = {
    package = ghosttyMain;
    enable = true;
    settings = {
      resize-overlay = "never";
      window-padding-x = 0;
      window-padding-y = 0;
      window-padding-balance = true;
      cursor-invert-fg-bg = true;
      window-decoration = false;
      confirm-close-surface = false;
      window-inherit-working-directory = false;
    };
  };

  programs.alacritty = {
    enable = true;
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
    package = helixMain;
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

  home.file = {
    "${config.xdg.configHome}/rofi".source = ../dots/rofi;
    "${config.xdg.configHome}/scripts" = {
      source = ../dots/scripts;
      executable = true;
    };
  };
}
