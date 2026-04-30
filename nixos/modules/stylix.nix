{
  stylix = {
    enable = true;
    autoEnable = true;
    inherit ((import ../../theme.nix)) base16Scheme;
    targets = {
      qt.enable = true;
      gtk.enable = true;
      chromium.enable = false;
    };
  };
}
