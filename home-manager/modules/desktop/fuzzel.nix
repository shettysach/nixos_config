{
  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        width = 37;
        lines = 10;
        horizontal-pad = 12;
        vertical-pad = 12;
        inner-pad = 6;
        line-height = 27;
      };

      border = {
        width = 1;
        radius = 0;
      };

      key-bindings = {
        prev = "Up";
        next = "Down";
        prev-with-wrap = "Control+p";
        next-with-wrap = "Control+n";
      };
    };
  };

  services.clipcat = {
    enable = true;
    enableSystemdUnit = true;
    menuSettings = {
      server_endpoint = "/run/user/1000/clipcat/grpc.sock";
      finder = "fuzzel";
      fuzzel = {
        menu_length = 10;
        menu_prompt = "> ";
        extra_arguments = ["--width=50"];
      };
    };
  };
}
