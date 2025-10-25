{pkgs, ...}: {
  stylix = {
    enable = true;
    autoEnable = true;

    # image = ../../wallpapers/aurora_ice.jpg;
    base16Scheme = ../../tokyonight.yaml;
    image = ../../wallpapers/matthew-stephenson.jpg;

    fonts = {
      serif = {
        name = "Lora";
        package = pkgs.lora;
      };

      sansSerif = {
        name = "Aileron";
        package = pkgs.aileron;
      };

      monospace = {
        # name = "BerkeleyMono Nerd Font";
        name = "JetBrainsMono Nerd Font";
        package = pkgs.nerd-fonts.jetbrains-mono;
      };

      sizes = {
        desktop = 12;
        applications = 12;
        terminal = 16;
      };
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Classic";
      size = 22;
    };

    opacity = {
      desktop = 0.85;
      terminal = 0.85;
    };

    iconTheme = {
      enable = true;
      package = pkgs.nordzy-icon-theme;
      dark = "Nordzy";
      light = "Nordzy";
    };
  };
}
