{pkgs, ...}: {
  stylix = {
    enable = true;
    autoEnable = true;

    base16Scheme = (import ../../theme.nix).base16Scheme;
    image = (import ../../theme.nix).image;

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
        name = "ZedMono NF Extd";
        package = pkgs.nerd-fonts.zed-mono;
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
      package = pkgs.vimix-icon-theme;
      dark = "Vimix-white";
      light = "Vimix-white";
    };
  };
}
