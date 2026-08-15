{
  lib,
  pkgs,
  # pkgs-stable,
  llmAgents,
  helium,
  cohle,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  imports = [./modules/mod.nix];

  home = {
    username = "sword";
    homeDirectory = "/home/sword";
    stateVersion = "26.05";
    pointerCursor.enable = true;
  };

  programs = {
    codex = {
      enable = true;
      package = llmAgents.codex;
    };

    pi-coding-agent = {
      enable = true;
      package = llmAgents.pi;
    };
  };

  home.packages = lib.attrValues {
    # GUI

    inherit (pkgs) firefox obsidian;
    inherit (pkgs) rustdesk-flutter;

    helium = helium;
    cohle = cohle;

    #

    inherit (pkgs) tokei;
  };

  # services.blueman-applet.enable = true;

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
}
