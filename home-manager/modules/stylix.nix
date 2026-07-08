{pkgs, ...}: {
  stylix = {
    enable = true;
    autoEnable = true;

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
        # name = "JetBrainsMono Nerd Font";
        # package = pkgs.nerd-fonts.jetbrains-mono;

        # name = "ZedMono NF Extd";
        # package = pkgs.nerd-fonts.zed-mono;

        name = "IoskeleyMono Nerd Font";
        package = pkgs.ioskeley-mono.normal-term-NF;
      };

      sizes = {
        applications = 13;
        desktop = 13;
        terminal = 14;
      };
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Classic";
      size = 22;
    };

    opacity = {
      terminal = 0.85;
      desktop = 0.85;
      applications = 1.0;
    };

    icons = {
      enable = true;
      package = pkgs.kdePackages.breeze-icons;
      light = "breeze";
      dark = "breeze-dark";
    };

    targets = {
      qt.enable = true;
      gtk.enable = true;
      gtk.extraCss = "* { border-radius: 0; }";
      spotify-player.enable = false;

      yazi.enable = false;
      zed.enable = false;
      fzf.enable = false;

      waybar = {
        addCss = true;
        opacity.enable = false;
      };
    };
  };
}
