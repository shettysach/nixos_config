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
      evtest
      # --
      playerctl
      pavucontrol
      # --
      # Dell
      dell-command-configure
      libsmbios
      openconnect
      ;
  };

  fonts.packages = lib.attrValues {
    inherit (pkgs) lora work-sans;
    inherit (pkgs.nerd-fonts) jetbrains-mono;
    inherit (pkgs.ioskeley-mono) term-nf nf;
  };
}
