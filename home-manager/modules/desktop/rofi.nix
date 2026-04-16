{
  lib,
  config,
  ...
}: {
  programs.rofi = {
    enable = true;
    terminal = "ghostty";
    extraConfig = {
      display-drun = "drun";
      display-window = "win";
      modi = "window,run,drun";
      show-icons = true;
    };
    theme = lib.mkAfter (
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in {
        window.width = mkLiteral "30%";
        element.padding = mkLiteral "0.5em";
        prompt.padding = mkLiteral "0.5em";
        entry.padding = mkLiteral "0.5em";
        element-icon.size = mkLiteral "1.2em";
        element-icon.padding = mkLiteral "0 0.5em 0 0";
        listview.columns = 1;
        listview.lines = 10;
        "element-text selected".highlight = mkLiteral "bold";
      }
    );
  };

  home.file = {
    "${config.xdg.configHome}/scripts" = {
      source = ../../dots/scripts;
      executable = true;
    };
  };
}
