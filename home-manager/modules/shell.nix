{
  config,
  lib,
  pkgs,
  ...
}: {
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
      shellAliases.zed = "zeditor";
      localVariables = {
        HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND = "";
        HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND = "";
        ZVM_VI_HIGHLIGHT_BACKGROUND = "blue";
        ZVM_VI_EDITOR = "nvim";
        ZVM_INIT_MODE = "sourcing";
      };
      syntaxHighlighting.styles.unknown-token = "fg=red";
      initContent = ''
        function zvm_after_init() {
            bindkey '^r' fzf-history-widget
        }
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:*' switch-group '<' '>'
        zstyle ':fzf-tab:*' fzf-flags --color=16 --preview-window=sharp --prompt='❯ '
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsr -1 $realpath'
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

    nushell = let
      hmSessionVarsNu = pkgs.runCommand "hm-session-vars.nu" {} ''
        echo "if (\$env.__HM_SESS_VARS_SOURCED? | is-empty) {''\$(${lib.getExe config.programs.nushell.package} -c "
        use ${pkgs.nu_scripts}/share/nu_scripts/modules/capture-foreign-env
        open ${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh | capture-foreign-env | to nuon
        ") | load-env}" >> "$out"
      '';
      dircolorsIntegration = pkgs.runCommand "dircolors.nu" {} ''
        eval "$(${lib.getExe' pkgs.coreutils "dircolors"} -b)"
        echo "export-env { \$env.LS_COLORS = \"$LS_COLORS\" }" >> $out
      '';
    in {
      enable = true;
      configFile.source = ../dots/nu/config.nu;
      envFile.text = ''
        source ${hmSessionVarsNu}
        source ${dircolorsIntegration}
        hide-env -i SSH_AUTH_SOCK
      '';
    };

    carapace = {
      enable = true;
      enableNushellIntegration = true;
      enableZshIntegration = false;
    };
  };
}
