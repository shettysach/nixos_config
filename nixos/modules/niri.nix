{pkgs, ...}: {
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  niri-flake.cache.enable = true;
  services.gnome.gnome-keyring.enable = true;
}
