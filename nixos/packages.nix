{
  lib,
  inputs,
  pkgs,
  pkgs-stable,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    package = inputs.neovim-nightly.packages.${pkgs.system}.default;
  };

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
      obsidian
      # -- TUI / CLI utils --
      ast-grep
      ripgrep
      lsr
      trashy
      fd
      file
      jq
      dua
      zip
      unzip
      killall
      powertop
      mpv
      imv
      # --
      networkmanagerapplet
      playerctl
      pulseaudio
      pulseaudio-ctl
      pavucontrol
      libnotify
      # -- GUI apps --
      brave
      # --
      # Dell
      dell-command-configure
      libsmbios
      ;

    inherit (pkgs.kdePackages) okular gwenview;

    inherit
      (pkgs-stable)
      newsflash
      ;

    helium = inputs.helium.packages.x86_64-linux.default;
    cohle = inputs.cohle.packages.${pkgs.system}.default;
  };

  fonts.packages = lib.attrValues {
    inherit (pkgs) lora work-sans;
    inherit (pkgs.nerd-fonts) jetbrains-mono zed-mono;
  };
}
