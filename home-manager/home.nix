{
  lib,
  pkgs,
  # pkgs-stable,
  llmAgents,
  spotifast,
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

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  # services.trayscale.enable = true;
  services.tailscale-systray.enable = true;

  services.safeeyes.enable = true;

  programs.dank-calendar = {
    enable = true;
    systemd.enable = true;
  };

  home.packages = lib.attrValues {
    # GUI

    inherit helium;
    inherit (pkgs) firefox;

    # inherit (pkgs) spotifast;
    inherit spotifast;
    inherit (pkgs) rustdesk-flutter evtest;
    inherit (pkgs) tokei;

    inherit cohle;
  };
}
