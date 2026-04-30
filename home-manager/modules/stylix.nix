{pkgs, ...}: {
  stylix = {
    enable = true;
    autoEnable = true;

    inherit ((import ../../theme.nix)) base16Scheme;
    inherit ((import ../../theme.nix)) image;

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
        name = "ZedMono NF Extd";
        package = pkgs.nerd-fonts.zed-mono;

        # name = "IoskeleyMono Nerd Font";
        # package = pkgs.ioskeley-mono.normal-NF;
      };

      sizes = {
        desktop = 12;
        applications = 13;
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
      desktop = 1.0;
      applications = 1.0;
    };

    icons = {
      enable = true;
      package = pkgs.tela-icon-theme;
      light = "Tela-nord-light";
      dark = "Tela-nord-dark";
    };

    targets = {
      qt.enable = true;
      gtk.enable = true;
      gtk.extraCss = "* { border-radius: 0; }";
      spotify-player.enable = false;
      yazi.enable = false;
      zed.enable = false;
      fzf.enable = false;
    };
  };
}
