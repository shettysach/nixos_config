{...}: {
  hardware.keyboard.qmk.enable = true;

  services.kmscon = {
    enable = true;
    config = {
      hwaccel = true;
      libseat = true;
    };
  };

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
}
