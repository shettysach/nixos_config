{
  pkgs,
  lib,
  ...
}: {
  imports = [./niri.nix ./waybar.nix ./lock.nix ./fuzzel.nix];

  services.mako = {
    enable = true;
    settings = {
      layer = "overlay";
      default-timeout = 5000;
      border-size = 1;
      ignore-timeout = false;

      width = 350;
      height = 350;
      max-icon-size = 80;
    };
  };

  services.gammastep = {
    enable = true;
    tray = true;
    provider = "manual";
    dawnTime = "05:00-07:00";
    duskTime = "18:00-21:00";
    temperature.night = 2700;
  };

  home.packages = lib.attrValues {
    inherit (pkgs) wlr-randr wl-mirror wl-clipboard;
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

  xdg.mimeApps = let
    fileManager = ["org.kde.dolphin.desktop"];
    browser = ["helium.desktop"];
    pdfViewer = ["org.pwmt.zathura-pdf-mupdf.desktop" "okularApplication_pdf.desktop"];
    imageViewer = ["imv.desktop"];
    commonDefaults = {
      "inode/directory" = fileManager;
      "x-directory/normal" = fileManager;
      "x-scheme-handler/file" = fileManager;
      "application/pdf" = pdfViewer;
      "image/*" = imageViewer;
    };
  in {
    enable = true;
    associations.added = commonDefaults;
    defaultApplications =
      commonDefaults
      // {
        "text/plain" = ["nvim.desktop"];

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
}
