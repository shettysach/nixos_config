{
  networking = {
    hostName = "nixos";
    firewall.enable = true;
    networkmanager.enable = false;
    wireless = {
      enable = false;
      iwd = {
        enable = true;
        settings.Scan.DisableRoamingScan = true;
      };
    };
  };

  # ports 1714 to 1764
  programs.kdeconnect.enable = true;

  services.tailscale.enable = true;
}
