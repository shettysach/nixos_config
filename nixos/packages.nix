{
  lib,
  inputs,
  pkgs,
  pkgs-stable,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = lib.attrValues {
    inherit
      (pkgs)
      # -- Nix --
      home-manager
      alejandra
      nixd
      nil
      cachix
      # -- Dev --
      git
      git-lfs
      difftastic
      neovim
      obsidian
      # -- TUI / CLI utils --
      ast-grep
      ripgrep
      lsd
      fd
      file
      jq
      dua
      killall
      powertop
      mpv
      imv
      zip
      unzip
      networkmanagerapplet
      playerctl
      pulseaudio
      pulseaudio-ctl
      pavucontrol
      libnotify
      # -- GUI apps --
      brave
      librewolf
      newsflash
      # --
      opencode
      amp-cli
      codex
      # Dell
      dell-command-configure
      libsmbios
      ;

    inherit (pkgs.kdePackages) okular gwenview;
    # inherit (pkgs-stable) librewolf;

    inherit (inputs.cohle.packages.${pkgs.system}) default;
  };

  fonts.packages = lib.attrValues {
    inherit (pkgs) lora work-sans;
    inherit (pkgs.nerd-fonts) jetbrains-mono zed-mono iosevka;
  };
}
