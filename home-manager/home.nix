{
  lib,
  pkgs,
  # pkgs-stable,
  llmAgents,
  helium,
  cohle,
  fastpotify,
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

    inherit helium;
    inherit (pkgs) firefox obsidian;
    inherit (pkgs) rustdesk-flutter;
    inherit (pkgs) evtest;

    #

    inherit (pkgs) tokei;

    inherit cohle;

    inherit fastpotify;
  };

  programs.dank-calendar = {
    enable = true;
    systemd.enable = true;
  };

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
}
