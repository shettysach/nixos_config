{
  pkgs,
  config,
  ...
}: {
  programs.zsh = {
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
      vim = "nvim";
      vimd = "neovide";

      fzfh = "fd -H . | fzf";
      fzfp = "fzf --preview 'bat --color=always {}'";

      zed = "MESA_VK_DEVICE_SELECT=10de:174d zeditor";
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
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color always --icon always $realpath'
    '';

    history.size = 1000;
    history.saveNoDups = true;
  };
}
