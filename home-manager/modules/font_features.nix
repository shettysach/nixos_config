{
  config,
  lib,
  ...
}: let
  inherit (config.stylix) fonts;

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
    lib.mkForce "${fonts.monospace.name}:${fontconfigFeatures}:size=${toString fonts.sizes.popups}";

  services.mako.settings.font =
    lib.mkForce "${fonts.sansSerif.name} ${toString fonts.sizes.desktop} #${features}";
}
