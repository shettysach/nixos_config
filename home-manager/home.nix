{...}: {
  imports = [./modules/mod.nix];

  home = {
    username = "sword";
    homeDirectory = "/home/sword";
    stateVersion = "24.05";
  };

  services.blueman-applet.enable = true;

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  services.gammastep = {
    enable = true;
    tray = true;
    provider = "manual";
    duskTime = "16:00-21:00";
    dawnTime = "06:00-09:00";
    temperature.night = 2700;
  };
}
