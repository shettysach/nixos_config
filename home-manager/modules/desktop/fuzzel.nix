{
  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        width = 35;
        lines = 10;
        horizontal-pad = 10;
        vertical-pad = 10;
        inner-pad = 5;
        line-height = 20;
        image-size-ratio = 1;
        prompt = "❯ ";
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

  systemd.user.services.clipcat.Unit.After = ["graphical-session.target"];
  services.clipcat = {
    enable = true;
    enableSystemdUnit = true;
    # Track only regular Ctrl+C clipboard changes. Watching and synchronizing
    # the Primary selection causes one file copy to be observed twice.
    daemonSettings = {
      synchronize_selection_with_clipboard = false;
      watcher.enable_primary = false;
    };
    menuSettings = {
      server_endpoint = "/run/user/1000/clipcat/grpc.sock";
      finder = "fuzzel";
      fuzzel = {
        menu_length = 10;
        menu_prompt = "❯ ";
        extra_arguments = ["--width=50"];
      };
    };
  };
}
