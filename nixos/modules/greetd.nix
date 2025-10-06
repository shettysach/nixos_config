{pkgs, ...}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = ''
          ${pkgs.tuigreet}/bin/tuigreet \
            --asterisks \
            --theme 'text=cyan;prompt=green;input=cyan' \
            --cmd niri-session
        '';
      };
    };
  };
}
