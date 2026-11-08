{pkgs, ...}: {
  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";
    inherit ((import ../../theme.nix)) base16Scheme;
    fonts = {
      monospace = {
        name = "IoskeleyMonoTerm Nerd Font Mono";
        package = pkgs.ioskeley-mono.term-nf;
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
