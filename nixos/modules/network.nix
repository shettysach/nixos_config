{pkgs, ...}: {
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;

    firewall = {
      enable = true;
    };
  };

  programs.nm-applet.enable = true;

  # ports 1714 to 1764
  programs.kdeconnect.enable = true;
  programs.kdeconnect.package = pkgs.kdePackages.kdeconnect-kde;
}
