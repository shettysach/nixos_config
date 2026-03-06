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
      file
      jq
      dua
      ripgrep
      lsd
      fd
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
      # Dell
      dell-command-configure
      libsmbios
      #
      wl-screenrec
      ;

    inherit (pkgs.kdePackages) okular gwenview;

    # inherit (pkgs.kdePackages) dolphin dolphin-plugins kservice;

    # inherit (pkgs-stable) librewolf;

    inherit (inputs.cohle.packages.${pkgs.system}) default;
  };

  programs.obs-studio = {
    enable = true;
    plugins = [pkgs.obs-studio-plugins.wlrobs];
  };

  fonts.packages = lib.attrValues {
    inherit (pkgs) lora work-sans;
    inherit (pkgs.nerd-fonts) jetbrains-mono;
  };
}
