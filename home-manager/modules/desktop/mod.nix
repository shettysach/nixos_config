{
  pkgs,
  lib,
  ...
}: let
  fileManager = ["org.kde.dolphin.desktop"];
  browser = ["helium.desktop"];
  pdfViewer = ["org.pwmt.zathura-pdf-mupdf.desktop" "okularApplication_pdf.desktop"];
in {
  imports = [./niri.nix ./waybar.nix ./lock.nix ./rofi.nix];

  services.wpaperd.enable = true;

  services.clipcat = {
    enable = true;
    enableSystemdUnit = true;
    menuSettings = {
      server_endpoint = "/run/user/1000/clipcat/grpc.sock";
      finder = "rofi";
      rofi = {
        menu_length = 10;
        menu_prompt = "Clipcat";
      };
    };
  };

  # Ensure WAYLAND_DISPLAY is available before clipcatd initializes its watcher.
  systemd.user.services.clipcat.Unit.After = ["graphical-session.target"];

  services.mako = {
    enable = true;
    settings = {
      layer = "overlay";
      default-timeout = 5000;
      border-size = 1;
    };
  };

  home.packages = lib.attrValues {
    inherit
      (pkgs)
      wlr-randr
      wl-mirror
      wl-clipboard
      ;
    inherit (pkgs) imv mpv;
    inherit (pkgs.kdePackages) dolphin gwenview okular;
  };

  xdg.portal = {
    enable = true;
    extraPortals = lib.attrValues {
      inherit (pkgs) xdg-desktop-portal-gtk;
    };
    config.niri = {
      default = ["gnome" "gtk"]; # Gnome portal for screensharing
      "org.freedesktop.impl.portal.FileChooser" = "gtk"; # gtk portal for files
    };
  };

  # -- Defaults

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "inode/directory" = fileManager;
      "x-directory/normal" = fileManager;
      "x-scheme-handler/file" = fileManager;
      "application/pdf" = pdfViewer;
    };
    defaultApplications = {
      "inode/directory" = fileManager;
      "x-directory/normal" = fileManager;
      "x-scheme-handler/file" = fileManager;
      "application/pdf" = pdfViewer;

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

  services.gammastep = {
    enable = true;
    tray = true;
    provider = "manual";
    dawnTime = "05:00-07:00";
    duskTime = "18:00-21:00";
    temperature.night = 2800;
  };
}
