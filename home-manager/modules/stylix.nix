{pkgs, ...}: {
  fonts.fontconfig.enable = true;

  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";

    inherit (import ../../theme.nix) base16Scheme image;

    fonts = {
      serif = {
        name = "Lora";
        package = pkgs.lora;
      };

      sansSerif = {
        name = "Work Sans";
        package = pkgs.work-sans;
      };

      monospace = {
        name = "IoskeleyMonoTerm Nerd Font Mono";
        package = pkgs.ioskeley-mono.term-nf;
      };

      sizes = {
        terminal = 14;
        popups = 14;
        desktop = 13;
        applications = 13;
      };
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Classic";
      size = 23;
    };

    opacity = {
      terminal = 0.85;
      desktop = 0.85;
      applications = 0.85;
      popups = 0.85;
    };

    icons = {
      enable = true;
      package = pkgs.kdePackages.breeze-icons;
      light = "breeze";
      dark = "breeze-dark";
    };

    targets = {
      waybar = {
        addCss = true;
        opacity.enable = true;
      };

      qt.enable = true;
      gtk.enable = true;
      rofi.enable = false;

      dank-calendar.enable = false;
      fzf.enable = false;
      neovim.enable = false;
      helix.enable = false;
      zed.enable = false;
      spotify-player.enable = false;
    };
  };
}
