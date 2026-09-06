{pkgs, ...}: {
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  niri-flake.cache.enable = true;
  services.gnome.gnome-keyring.enable = true;

  programs.gtklock = {
    enable = true;
    style = ''
      window #clock-label, window #date-label {
        text-shadow: 4px 4px 6px #000000;
      }
    '';
    config = {
      main = {
        background = "${(import ../../theme.nix).image}";
        time-format = "%H:%M";
        date-format = "%A, %d %B %Y";
        idle-hide = false;
      };

      playerctl = {
        art-size = 96;
        show-hidden = false;
      };

      powerbar = {show-labels = false;};
    };
    modules = with pkgs; [
      gtklock-powerbar-module
      gtklock-playerctl-module
    ];
  };
}
