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
        name = "Iosevka Aile";
        package = pkgs.iosevka-bin.override {variant = "Aile";};
      };

      monospace = {
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
  };
}
