{pkgs, ...}: {
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --asterisks --theme 'text=blue;input=blue' --remember --cmd niri-session";
      };
    };
  };
}
