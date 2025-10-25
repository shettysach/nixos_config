{ pkgs, ... }:
let
  fileManager = [ "org.xfce.Thunar.desktop" ];
  browser = [ "brave-browser.desktop" ];
  # fileManager = ["org.kde.dolphin.desktop"];
in
{
  programs.niri = {
    enable = true;
    package = pkgs.niri-stable;
  };

  niri-flake.cache.enable = true;

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
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
    };
  };
}
