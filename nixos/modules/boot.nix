{pkgs, ...}: {
  boot.kernelPackages = pkgs.linuxPackages_latest;

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  # Resume from the swapfile above. `resume_offset` is the first physical
  # extent reported by `filefrag -v /var/lib/swapfile`; update it if the
  # swapfile is ever recreated.
  boot.resumeDevice = "/dev/disk/by-uuid/afcae664-7a8f-4895-bc82-04bf4d690f86";

  # https://chrisdown.name/2026/03/24/zswap-vs-zram-when-to-use-what.html

  boot.kernelParams = [
    "resume_offset=74072064"
    "zswap.enabled=1" # enables zswap
    "zswap.compressor=lz4" # compression algorithm
    "zswap.max_pool_percent=20" # maximum percentage of RAM that zswap is allowed to use
    "zswap.shrinker_enabled=1" # whether to shrink the pool proactively on high memory pressure
  ];

  # Needed for lz4
  boot.initrd = {
    kernelModules = ["lz4"];
  };

  # Avoid the firmware-managed S4 transition, which briefly wakes the panel
  # while entering hibernation. The saved image is still restored normally.
  systemd.sleep.settings.Sleep.HibernateMode = "shutdown";

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
}
