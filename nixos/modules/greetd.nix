{
  inputs,
  pkgs,
  ...
}: let
  tuigreet = inputs.tuigreet.packages.${pkgs.stdenv.hostPlatform.system}.tuigreet;
in {
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings = {
      default_session = {
        command = "${tuigreet}/bin/tuigreet --asterisks --theme 'prompt=green;text=cyan;input=cyan' --remember --cmd niri-session";
      };
    };
  };
}
