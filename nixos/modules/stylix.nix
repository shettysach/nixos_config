{pkgs, ...}: {
  services.kmscon = {
    enable = false;
    config = {
      term = "kmscon";
      hwaccel = true;
      libseat = true;
    };
  };

  stylix = {
    enable = true;
    autoEnable = true;
    inherit ((import ../../theme.nix)) base16Scheme;
    fonts = {
      monospace = {
        name = "IoskeleyMono Nerd Font";
        package = pkgs.ioskeley-mono.normal-NF;
      };
    };
    targets = {
      qt.enable = true;
      gtk.enable = true;
      chromium.enable = false;
    };
  };
}
