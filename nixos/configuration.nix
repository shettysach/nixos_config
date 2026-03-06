{
  pkgs,
  inputs,
  ...
}: {
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.fwupd.enable = true;

  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ./modules/mod.nix
    ./intel.nix
    ./nvidia.nix
  ];

  nixpkgs.overlays = [inputs.niri.overlays.niri];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  users.users.sword = {
    isNormalUser = true;
    description = "Sword";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
    ];
  };

  environment.variables.EDITOR = "nvim";

  programs = {
    nix-ld.enable = true;
    light.enable = true;
    zsh.enable = true;
  };

  nix.settings = {
    trusted-users = ["root" "sword"];
    substituters = [
      "https://nix-community.cachix.org"
      "https://niri.cachix.org"
      "https://ghostty.cachix.org"
      "https://zed-industries.cachix.org"
      "https://helix.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
      "zed-industries.cachix.org-1:fgVpvtdF+ssrgP1lB6EusuR3uM6bNcncWduKxri3u6Y="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
    ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.tmp.useTmpfs = true

  # time.timeZone = "Asia/Kolkata";
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_GB.UTF-8";

  # SSH and SCP
  services.sshd.enable = true;
  networking.firewall.allowedTCPPorts = [22];

  security.polkit.enable = true;
  security.rtkit.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  system.nssDatabases.hosts = [
    "files mdns_minimal [NOTFOUND=return] dns mdns"
  ];

  services.libinput.enable = true;

  services.libinput.touchpad = {
    tapping = true; # optional: off while testing buttons
    clickMethod = "buttonareas";
    scrollMethod = "twofinger";
    naturalScrolling = true;
    disableWhileTyping = true;
    middleEmulation = true;
  };

  systemd.services.unbind-touchscreen = {
    description = "Unbind ELAN2097 touchscreen from hid-multitouch";
    wantedBy = ["multi-user.target"];
    after = ["sysinit.target"];

    serviceConfig = {
      Type = "oneshot";
      SuccessExitStatus = [0 1];
    };

    script = ''
      set -eu

      dev="0018:04F3:2540.0001"
      driver="/sys/bus/hid/drivers/hid-multitouch"

      # If the device doesn't exist, nothing to do.
      if [ ! -e "/sys/bus/hid/devices/$dev" ]; then
        exit 0
      fi

      # If it's already unbound, there will be no driver symlink.
      if [ ! -e "/sys/bus/hid/devices/$dev/driver" ]; then
        exit 0
      fi

      # Only unbind if it's currently bound to hid-multitouch.
      if readlink -f "/sys/bus/hid/devices/$dev/driver" | grep -q "/hid-multitouch\$"; then
        echo "$dev" > "$driver/unbind" || true
      fi

      exit 0
    '';
  };

  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
    #media-session.enable = true;
  };

  services.gvfs.enable = true;
  # services.udev.packages = [ pkgs.android-udev-rules pkgs.libmtp.out ];

  system.stateVersion = "24.05";
}
