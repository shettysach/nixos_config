{
  lib,
  pkgs,
  # pkgs-stable,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;

  environment.systemPackages = lib.attrValues {
    inherit
      (pkgs)
      # -- Nix --
      home-manager
      alejandra
      cachix
      # -- Dev --
      git
      git-lfs
      difftastic
      # -- TUI / CLI utils --
      microfetch
      ripgrep
      trashy
      lsr
      fd
      file
      jq
      dua
      zip
      unzip
      killall
      powertop
      libnotify
      # --
      playerctl
      pavucontrol
      # --
      # Dell
      dell-command-configure
      libsmbios
      ;
  };

  fonts.packages = lib.attrValues {
    inherit (pkgs) lora work-sans;
    iosevka-aile = pkgs.iosevka-bin.override {variant = "Aile";};
    inherit (pkgs.nerd-fonts) jetbrains-mono zed-mono;
    inherit (pkgs.ioskeley-mono) normal-term-NF;
  };
}
