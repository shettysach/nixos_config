{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.overlays = [inputs.niri.overlays.niri];
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ./modules/mod.nix
    ./intel.nix
    # ./nvidia.nix
  ];

  users.users.sword = {
    isNormalUser = true;
    description = "Sword";
    extraGroups = ["networkmanager" "wheel" "video" "bluetooth"];
  };

  programs.zsh.enable = true;
  users.users.sword.shell = pkgs.zsh;
  environment.variables.EDITOR = "nvim";

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_GB.UTF-8";

  # SSH and SCP
  services.sshd.enable = false;
  networking.firewall.allowedTCPPorts = [22];

  security.polkit.enable = true;
  security.rtkit.enable = true;

  system.nssDatabases.hosts = [
    "files mdns_minimal [NOTFOUND=return] dns mdns"
  ];

  services.gvfs.enable = true;

  system.stateVersion = "24.05";
}
