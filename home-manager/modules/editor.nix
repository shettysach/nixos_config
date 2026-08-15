{neovim-nightly, ...}: {
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      sideloadInitLua = true;
      package = neovim-nightly;
    };

    zed-editor.enable = true;

    helix = {
      enable = true;
      settings = {
        editor = {
          line-number = "relative";
          bufferline = "multiple";
          popup-border = "all";
          color-modes = true;
          soft-wrap.enable = true;
          completion-trigger-len = 1;
          completion-replace = true;
          completion-timeout = 100;
          end-of-line-diagnostics = "hint";
          inline-diagnostics.cursor-line = "hint";
          cursor-shape = {
            insert = "bar";
            select = "underline";
          };
          file-picker.hidden = false;
        };

        keys = {
          normal = {
            esc = ["collapse_selection" "keep_primary_selection"];
            tab = ":buffer-next";
            "S-tab" = ":buffer-previous";
            space.i = ":toggle-option lsp.display-inlay-hints";
          };
        };
      };

      languages = {
        language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = "alejandra";
          }
          {
            name = "haskell";
            auto-format = true;
          }
          {
            name = "python";
            language-servers = ["ty" "ruff"];
          }
        ];

        language-server = {
          rust-analyzer = {
            config = {
              provideFormatter = true;
              cargo.features = "all";
              check.command = "clippy";
            };
          };

          haskell-language-server.config = {
            haskell.formattingProvider = "stylish-haskell";
            haskell.plugin.rename.config.crossModule = true;
          };
        };
      };

      themes.transparent = {
        "ui.background" = {fg = "fg";};
        "ui.text" = {fg = "fg";};
      };
    };
  };
}
