{
  config,
  pkgs,
  ...
}: {
  # Enable OpenGL
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["modesetting" "nvidia"];

  environment.systemPackages = [pkgs.nvtopPackages.nvidia];

  # Make NVIDIA the default renderer for the Wayland session and applications.
  environment.sessionVariables = {
    __NV_PRIME_RENDER_OFFLOAD = "1";
    __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    __VK_LAYER_NV_optimus = "NVIDIA_only";
  };

  # Optimus PRIME
  hardware.nvidia.prime = {
    # NOTE: Sync and Offload are mutually exclusive
    sync.enable = true;

    offload.enable = false;
    offload.enableOffloadCmd = false;

    # Make sure to use the correct Bus ID values for your system!
    # intelBusId = "0@0:2:0";
    # nvidiaBusId = "1@0:0:0";

    intelBusId = "PCI:0:0:2";
    nvidiaBusId = "PCI:1:0:0";
  };

  hardware.nvidia = {
    nvidiaPersistenced = false;

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };
}
