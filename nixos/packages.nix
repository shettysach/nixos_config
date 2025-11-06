{
  lib,
  inputs,
  pkgs,
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
      # -- Dev --
      git
      git-lfs
      difftastic
      nix-direnv
      direnv
      neovim
      neovide
      nushell
      obsidian
      texliveSmall
      # --
      opencode
      claude-code
      # -- TUI / CLI utils --
      fastfetch
      file
      jq
      joshuto
      dua
      zoxide
      ripgrep
      lsr
      bat
      delta
      fzf
      fd
      killall
      btop
      mpv
      imv
      zip
      unzip
      networkmanagerapplet
      playerctl
      pulseaudio
      pulseaudio-ctl
      pavucontrol
      # -- wayland  --
      wl-clipboard
      wlr-randr
      clipse
      waybar
      libnotify
      swayidle
      swaylock
      # -- GUI apps --
      brave
      librewolf
      newsflash
      zathura
      # fractal
      ;

    inherit (pkgs.kdePackages) okular;

    # inherit (pkgs.kdePackages) dolphin dolphin-plugins;

    inherit (pkgs.xfce) thunar thunar-volman thunar-archive-plugin thunar-media-tags-plugin tumbler;

    inherit (pkgs.nvtopPackages) nvidia;

    cohle = inputs.cohle.packages.${pkgs.system}.default;
  };

  fonts.packages = lib.attrValues {
    inherit (pkgs) lora work-sans;
    inherit (pkgs.nerd-fonts) jetbrains-mono;
  };
}
