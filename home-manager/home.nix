{
  lib,
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

  home.packages = lib.attrValues {
    inherit (llmAgents) opencode amp;
    inherit (pkgs) obsidian nufmt;
    inherit (pkgs-stable) newsflash;
  };

  # services.blueman-applet.enable = true;

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
}
