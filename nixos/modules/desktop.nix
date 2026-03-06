{
  lib,
  pkgs,
  ...
}: let
  browser = ["brave-browser.desktop"];
  fileManager = ["org.xfce.Thunar.desktop"]; # ["org.kde.dolphin.desktop"];
in {
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };
  niri-flake.cache.enable = true;

  environment.systemPackages = lib.attrValues {
    inherit (pkgs) wlr-randr wl-clipboard clipse;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-volman
      thunar-archive-plugin
      thunar-media-tags-plugin
      tumbler
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
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
    };
  };
}
