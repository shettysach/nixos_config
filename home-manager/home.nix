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
    stateVersion = "26.11";
    pointerCursor.enable = true;
  };

  programs = {
    git.enable = true;

    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
      settings = {
        git_protocol = "https";
        editor = "nvim";
      };
    };

    codex = {
      enable = true;
      package = llmAgents.codex;
    };
  };

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  services.tailscale-systray.enable = true;
  # services.trayscale.enable = true;

  # services.safeeyes.enable = true;

  programs.dank-calendar = {
    enable = true;
    systemd.enable = true;
  };

  home.packages = lib.attrValues {
    # GUI

    inherit helium;
    inherit (pkgs) firefox herdr-desktop;

    inherit (llmAgents) chatgpt;

    inherit (pkgs) spotifast;
    inherit (pkgs) rustdesk-flutter evtest;
    inherit (pkgs) tokei;

    inherit cohle;
  };
}
