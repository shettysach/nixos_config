{
  lib,
  inputs,
  pkgs,
  # pkgs-stable,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;

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
      cachix
      # -- Dev --
      git
      git-lfs
      difftastic
      nufmt
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
      networkmanager
      networkmanagerapplet
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
    inherit (pkgs.nerd-fonts) jetbrains-mono zed-mono;
    inherit (pkgs.ioskeley-mono) normal-NF;
  };
}
