{pkgs, ...}: let
  fileManager = ["org.xfce.Thunar.desktop"];
  # fileManager = ["org.kde.dolphin.desktop"];
in {
  programs.niri = {
    enable = true;
    package = pkgs.niri-stable;
  };

  niri-flake.cache.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      kdePackages.xdg-desktop-portal-kde
    ];

    config.common.default = "*";
    config.niri = {
      default = "gtk";
      "org.freedesktop.impl.portal.Secret" = ["kwallet"];
      "org.freedesktop.impl.portal.OpenURI" = ["gtk"];
      "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
    };
  };

  xdg.mime = {
    enable = true;
    addedAssociations = {
      "inode/directory" = fileManager;
      "x-directory/normal" = fileManager;
      "x-scheme-handler/file" = fileManager;
    };
    defaultApplications = {
      "inode/directory" = fileManager;
      "x-directory/normal" = fileManager;
      "x-scheme-handler/file" = fileManager;
    };
  };
}
