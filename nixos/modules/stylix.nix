{
  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = (import ../../theme.nix).base16Scheme;
    targets = {
      qt.enable = true;
      gtk.enable = true;
      chromium.enable = false;
    };
  };
}
