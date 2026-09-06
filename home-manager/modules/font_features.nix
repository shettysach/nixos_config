{
  config,
  lib,
  ...
}: let
  inherit (config.stylix.fonts) monospace sizes;

  fontFeatures = {
    calt = false;
    zero = true;
  };

  features =
    lib.concatStringsSep ","
    (lib.mapAttrsToList
      (feature: enabled: "${feature}=${
        if enabled
        then "1"
        else "0"
      }")
      fontFeatures);

  fontconfigFeatures =
    lib.concatStringsSep ":"
    (lib.mapAttrsToList
      (feature: enabled: "fontfeatures=${lib.optionalString (!enabled) "-"}${feature}")
      fontFeatures);
in {
  programs.ghostty.settings.font-feature =
    features;

  programs.waybar.style =
    lib.mkAfter ''* { font-feature-settings: "${features}"; }'';

  programs.fuzzel.settings.main.font =
    lib.mkForce "${monospace.name}:${fontconfigFeatures}:size=${toString sizes.popups}";

  services.mako.settings.font =
    lib.mkForce "${monospace.name} ${toString sizes.desktop} #${features}";
}
