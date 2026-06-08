{pkgs, ...}: let
  #  fileManager = ["org.xfce.Thunar.desktop"];
  fileManager = ["org.kde.dolphin.desktop"];
in {
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };
  niri-flake.cache.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
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
