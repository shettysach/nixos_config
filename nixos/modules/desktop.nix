{pkgs, ...}: let
  image = (import ../../theme.nix).image;
  lockBackground = pkgs.runCommand "gtklock-background.jpg" {
    nativeBuildInputs = [pkgs.imagemagick];
  } ''magick ${image} -brightness-contrast -35x0 "$out" '';
in {
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  niri-flake.cache.enable = true;
  services.gnome.gnome-keyring.enable = true;

  programs.gtklock = {
    enable = true;
    config = {
      main = {
        background = "${lockBackground}";
        time-format = "%H:%M";
        date-format = "%A, %d %B %Y";
        idle-hide = true;
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
