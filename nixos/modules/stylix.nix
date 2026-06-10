{pkgs, ...}: {
  stylix = {
    enable = true;
    autoEnable = true;
    inherit ((import ../../theme.nix)) base16Scheme;
    fonts = {
      monospace = {
        name = "IoskeleyMono Nerd Font";
        package = pkgs.ioskeley-mono.normal-NF;
      };
      sizes.terminal = 14;
    };
    targets = {
      qt.enable = true;
      gtk.enable = true;
      chromium.enable = false;
    };
  };
}
