{
  pkgs,
  lib,
  ...
}: let
  #  fileManager = ["org.xfce.Thunar.desktop"];
  fileManager = ["org.kde.dolphin.desktop"];
  browser = ["helium.desktop"];
in {
  imports = [./niri.nix ./waybar.nix ./lock.nix ./rofi.nix];

  services.wpaperd.enable = true;

  services.clipse = {
    enable = true;
    systemdTarget = "graphical-session.target";
  };

  home.packages = lib.attrValues {
    inherit (pkgs) wlr-randr wl-clipboard clipse imv mpv;
    inherit (pkgs.kdePackages) dolphin gwenview okular;
  };

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

  # -- Explorer

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "inode/directory" = fileManager;
      "x-directory/normal" = fileManager;
      "x-scheme-handler/file" = fileManager;
    };
    defaultApplications = {
      "inode/directory" = fileManager;
      "x-directory/normal" = fileManager;
      "x-scheme-handler/file" = fileManager;

      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "text/html" = browser;
    };
  };

  # -- Dolphin

  xdg.configFile."menus/applications.menu".text = ''
    <!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
     "http://www.freedesktop.org/standards/menu-spec/1.0/menu.dtd">

    <Menu>
      <Name>Applications</Name>
      <DefaultAppDirs/>
      <DefaultDirectoryDirs/>
      <Include><All/></Include>
      <DefaultLayout>
        <Merge type="menus"/>
        <Merge type="files" />
      </DefaultLayout>
      <DefaultMergeDirs/>
    </Menu>
  '';

  # -- Thunar

  # programs.thunar = {
  #   enable = false;
  #   plugins = with pkgs; [
  #     thunar-volman
  #     thunar-archive-plugin
  #     thunar-media-tags-plugin
  #     tumbler
  #   ];
  # };

  # --

  services.mako = {
    enable = true;
    settings.default-timeout = 5000;
  };

  services.gammastep = {
    enable = true;
    tray = true;
    provider = "manual";
    dawnTime = "05:00-07:00";
    duskTime = "18:00-21:00";
    temperature.night = 2200;
  };
}
