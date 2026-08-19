{
  programs.starship = {
    enable = true;
    settings = {
      format = builtins.concatStringsSep "" [
        "$directory"
        "[](fg:blue bg:#394260)"
        "$git_branch"
        "$git_status"
        "[](fg:#394260 bg:#2b3248)"
        "$python"
        "$rust"
        "$haskell"
        "$c"
        "$cpp"
        "$odin"
        "[](fg:#2b3248 bg:#1d2230)"
        "$nix_shell"
        "[](fg:#1d2230)"
        "\n\$jobs$character"
      ];

      directory = {
        style = "bold fg:black bg:blue";
        format = "[ $path ]($style)";
      };

      git_branch = {
        symbol = "";
        style = "fg:bright-blue bg:#394260";
        format = "[ $symbol $branch ]($style)";
      };

      git_status = {
        deleted = "x";
        style = "fg:bright-blue bg:#394260";
        format = "[$all_status$ahead_behind ]($style)";
      };

      python = {
        symbol = "󰌠";
        style = "fg:bright-blue bg:#2b3248";
        format = "[ $symbol ($version) ]($style)";
        python_binary = ".venv/bin/python";
      };

      rust = {
        symbol = "";
        style = "fg:bright-blue bg:#2b3248";
        format = "[ $symbol ($version) ]($style)";
      };

      haskell = {
        symbol = "";
        style = "fg:bright-blue bg:#2b3248";
        format = "[ $symbol ($version) ]($style)";
      };

      c = {
        symbol = "";
        style = "fg:bright-blue bg:#2b3248";
        format = "[ $symbol ($version) ]($style)";
      };

      cpp = {
        symbol = "";
        style = "fg:bright-blue bg:#2b3248";
        format = "[ $symbol ($version) ]($style)";
      };

      odin = {
        symbol = "Ø";
        style = "fg:bright-blue bg:#2b3248";
        format = "[ $symbol ($version) ]($style)";
      };

      nix_shell = {
        disabled = false;
        impure_msg = "[](fg:blue bg:#1d2230)";
        pure_msg = "[](fg:green bg:#1d2230)";
        unknown_msg = "[](fg:purple bg:#1d2230)";
        format = "[ $state ($name) ](fg:blue bg:#1d2230)";
      };
    };
  };
}
