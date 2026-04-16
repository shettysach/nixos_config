{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./niri.nix
    ./waybar.nix
    ./lock.nix
    ./rofi.nix
  ];

  xdg.portal = {
    enable = true;
    extraPortals = lib.attrValues {
      inherit
        (pkgs)
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
        ;
    };

    config.common.default = "*";
  };

  services.mako = {
    enable = true;
    settings.default-timeout = 5000;
  };

  services.wpaperd.enable = true;
  services.gammastep = {
    enable = true;
    tray = true;
    provider = "manual";
    duskTime = "18:00-21:00";
    dawnTime = "05:00-07:00";
    temperature.night = 2500;
  };
}
