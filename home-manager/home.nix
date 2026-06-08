{
  lib,
  inputs,
  pkgs,
  pkgs-stable,
  llmAgents,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  imports = [./modules/mod.nix];

  home = {
    username = "sword";
    homeDirectory = "/home/sword";
    stateVersion = "26.05";
  };

  programs = {
    codex = {
      enable = true;
      package = llmAgents.codex;
    };

    opencode = {
      enable = true;
      package = llmAgents.opencode;
    };
  };

  home.packages = lib.attrValues {
    inherit (llmAgents) amp;

    inherit (pkgs) firefox obsidian;
    helium = inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default;

    # cohle = inputs.cohle.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };

  # services.blueman-applet.enable = true;

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
}
