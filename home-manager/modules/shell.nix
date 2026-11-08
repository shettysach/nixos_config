{pkgs, ...}: {
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autosuggestion = {
        enable = true;
        strategy = ["history" "completion"];
      };
      history.size = 1000;
      history.saveNoDups = true;
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
        x = "xdg-open";
        zed = "zeditor";
      };

      localVariables = {
        HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND = "";
        HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND = "";
        ZVM_VI_HIGHLIGHT_BACKGROUND = "blue";
        ZVM_VI_EDITOR = "nvim";
        ZVM_INIT_MODE = "sourcing";
      };
      syntaxHighlighting.styles.unknown-token = "fg=red";
      initContent =
        #zsh
        ''
          function zvm_after_init() { bindkey '^r' fzf-history-widget }

          bindkey '^ ' autosuggest-accept

          zstyle ':completion:*' menu no
          zstyle ':fzf-tab:*' switch-group '<' '>'
          zstyle ':fzf-tab:*' fzf-flags --color=16 --preview-window=sharp --prompt='❯ '
          zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsr -1 $realpath'

          precmd() { precmd() { echo } }
          alias clear="precmd() { precmd() { echo } } && clear"
        '';
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultOptions = [
        "--color base16"
        "--layout reverse"
        "--preview-window right:50%:sharp"
        "--prompt '❯ '"
      ];
      fileWidget = {
        command = "fd --type f";
        options = ["--preview 'bat --color always {}'"];
      };
    };

    bat.enable = true;
    zoxide.enable = true;

    # ---

    dircolors.enable = true;

    nushell = {
      enable = true;
      configFile.source = ../dots/nu/config.nu;
    };

    carapace = {
      enable = true;
      enableNushellIntegration = true;
      enableZshIntegration = false;
    };
  };
}
