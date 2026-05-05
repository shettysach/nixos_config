{
  pkgs,
  inputs,
  ...
}: {
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nixpkgs.overlays = [inputs.niri.overlays.niri];
  nix.settings = {
    trusted-users = ["root" "sword"];
    experimental-features = ["nix-command" "flakes"];
  };

  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ./modules/mod.nix
    ./intel.nix
    # ./nvidia.nix
  ];

  # --

  users.users.sword = {
    isNormalUser = true;
    description = "Sword";
    shell = pkgs.nushell;
    extraGroups = ["networkmanager" "wheel" "video"];
  };

  environment.shells = [pkgs.nushell];
  programs.bash.interactiveShellInit = ''
    if ! [ "$TERM" = "dumb" ] && [ -z "$BASH_EXECUTION_STRING" ]; then
      exec nu
    fi
  '';

  # -- Swap

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  # https://chrisdown.name/2026/03/24/zswap-vs-zram-when-to-use-what.html

  boot.kernelParams = [
    "zswap.enabled=1" # enables zswap
    "zswap.compressor=lz4" # compression algorithm
    "zswap.max_pool_percent=20" # maximum percentage of RAM that zswap is allowed to use
    "zswap.shrinker_enabled=1" # whether to shrink the pool proactively on high memory pressure
  ];

  # Needed for lz4
  boot.initrd = {
    systemd.enable = true;
    kernelModules = ["lz4"];
  };

  # --

  environment.variables.EDITOR = "nvim";

  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
      "https://niri.cachix.org"
      "https://ghostty.cachix.org"
      "https://cache.numtide.com"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  # --

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.tmp.useTmpfs = true

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

  # -- Input / Output

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

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
    description = "Unbind ELAN2097 touchscreen/stylus from hid-multitouch";
    wantedBy = ["multi-user.target"];
    after = ["sysinit.target"];
    serviceConfig = {
      Type = "oneshot";
      SuccessExitStatus = [0 1];
    };

    script = ''
      set -eu

      # Touchscreen + stylus share this HID device (04F3:2540). The instance
      # suffix (.0001/.0002/...) can change across boots.
      driver="/sys/bus/hid/drivers/hid-multitouch"

      for devpath in /sys/bus/hid/devices/0018:04F3:2540.*; do
        # If the glob doesn't match, devpath will be the literal pattern.
        if [ ! -e "$devpath" ]; then
          continue
        fi

        # If it's already unbound, there will be no driver symlink.
        if [ ! -e "$devpath/driver" ]; then
          continue
        fi

        # Only unbind if it's currently bound to hid-multitouch.
        if readlink -f "$devpath/driver" | grep -q "/hid-multitouch\$"; then
          echo "$(basename "$devpath")" > "$driver/unbind" || true
        fi
      done

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

  # --

  services.gvfs.enable = true;
  # services.udev.packages = [ pkgs.android-udev-rules pkgs.libmtp.out ];

  system.stateVersion = "24.05";
}
