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
        name = "IoskeleyMono Nerd Font";
        package = pkgs.ioskeley-mono.normal-term-NF;
      };

      monospace = {
        name = "IoskeleyMono Nerd Font";
        package = pkgs.ioskeley-mono.normal-term-NF;
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
      size = 22;
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
  };
}
