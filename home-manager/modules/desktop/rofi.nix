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
        element.spacing = mkLiteral "0.5em";
        element-icon.size = mkLiteral "1.1em";
        element-text.vertical-align = mkLiteral "0.5";
        listview.columns = 1;
        listview.lines = 10;
      }
    );
  };
}
