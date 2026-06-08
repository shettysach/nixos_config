{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;

    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = false;
      };
    };
  };

  services.blueman = {
    enable = true;
  };
}
