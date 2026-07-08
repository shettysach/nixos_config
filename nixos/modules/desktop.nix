{pkgs, ...}: {
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };
  niri-flake.cache.enable = true;
  security.pam.services.hyprlock = {};
}
